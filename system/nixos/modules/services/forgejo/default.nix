{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) str attrs int;

  cfg = config.module.services.forgejo;
in {
  options = {
    module.services.forgejo = {
      enable = mkEnableOption "Enable forgejo";

      package = mkOption {
        type = lib.types.package;
        default = pkgs.forgejo;
        description = "Forgejo package";
      };

      stateDir = mkOption {
        type = str;
        default = "/var/lib/forgejo";
        description = "Forgejo data dir";
      };

      database = mkOption {
        type = attrs;
        default = {};
        description = "Forgejo database settings";
      };

      domain = mkOption {
        type = str;
        default = "git.example.com";
        description = "Forgejo domain name";
      };

      sshPort = mkOption {
        type = int;
        default = 222;
        description = "Forgejo ssh port";
      };

      httpAddr = mkOption {
        type = str;
        default = "127.0.0.1";
        description = "Forgejo listen address";
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      certs = {
        ${config.module.services.forgejo.domain}.email = "aj001@mail.ru";
      };
    };

    services.nginx.virtualHosts.${config.module.services.forgejo.domain} = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/" = {
        proxyPass = "http://localhost:3000";
      };
    };

    services.forgejo = {
      inherit (cfg) database stateDir;

      enable = true;
      package = cfg.package;
      # Enable support for Git Large File Storage
      lfs.enable = true;
      settings = let
        gcArgs = "--aggressive --no-cruft --prune=now";
        gcTimeout = 600;
      in {
        "cron.cleanup_actions".ENABLED = true;
        "cron.update_mirrors".SCHEDULE = "@midnight";
        "git".GC_ARGS = gcArgs;
        "git.timeout".GC = gcTimeout;
        "log".LEVEL = "Error";
        "repo-archive".ENABLED = false;
        "repository".DISABLE_DOWNLOAD_SOURCE_ARCHIVES = true;
        "repository.issue".MAX_PINNED = 99999;
        "repository.pull-request".DEFAULT_MERGE_STYLE = "rebase";
        "service".DISABLE_REGISTRATION = true;
        "service".REQUIRE_SIGNIN_VIEW = true;

        "server" = {
          DOMAIN = cfg.domain;
          HTTP_ADDR = cfg.httpAddr;
          ROOT_URL = "https://${cfg.domain}";
          BUILTIN_SSH_SERVER_USER = "git";
          DISABLE_SSH = false;
          SSH_PORT = cfg.sshPort;
          START_SSH_SERVER = true;
        };

        "openid" = {
          ENABLE_OPENID_SIGNUP = true;
        };

        "oauth2_client" = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "auto";
        };

        "ui" = {
          AMBIGUOUS_UNICODE_DETECTION = false;
        };

        "repository" = {
          #DEFAULT_PRIVATE = "private";
          #DEFAULT_PUSH_CREATE_PRIVATE = true;
        };

        "cron" = {
          ENABLED = true;
          RUN_AT_START = true;
        };

        "cron.git_gc_repos" = {
          ENABLED = true;
          ARGS = gcArgs;
          SCHEDULE = "@midnight";
          TIMEOUT = gcTimeout;
        };

        "cron.archive_cleanup" = {
          ENABLED = true;
          RUN_AT_START = true;
          SCHEDULE = "@midnight";
          TIMEOUT = "1h";
        };
      };
    };

    sops = {
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = {
        forgejo_alienjust_pass = {
          neededForUsers = false;
          sopsFile = ../../../../../secrets/secrets.yaml;
        };
      };
    };

    sops.secrets.forgejo_alienjust_pass.owner = "forgejo";

    systemd.services.forgejo.preStart = let
      adminCmd = "${lib.getExe cfg.package} admin user";
      pwd = config.sops.secrets.forgejo_alienjust_pass;
      user = "alienjust"; # Note, Forgejo doesn't allow creation of an account named "admin"
    in ''
      ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
      ## uncomment this line to change an admin user which was already created
      # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
  };
}
