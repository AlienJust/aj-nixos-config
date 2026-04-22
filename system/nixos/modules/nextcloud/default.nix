{
  self,
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.nextcloud;
  # hpb = pkgs.callPackage "${self}/pkgs/hpb" {};
in {
  options = {
    module.nextcloud.enable = mkEnableOption "Enables nextcloud";
    module.nextcloud.hostname = mkOption {
      type = types.str;
      description = "Nextcloud hostname";
      default = "";
    };
  };
  config = mkIf cfg.enable {
    sops = {
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = {
        nextcloud_admin_pass = {
          neededForUsers = false;
          sopsFile = ../../../../secrets/secrets.yaml;
        };
      };
    };

    environment.etc."nextcloud-admin-pass".text = config.sops.secrets.nextcloud_admin_pass.path;
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud33;
      config.adminpassFile = "/etc/nextcloud-admin-pass";

      config.dbtype = "sqlite";

      configureRedis = true;

      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) richdocuments;
      };

      # Автоматическая настройка URL сервера (необязательно, можно сделать в UI)
      settings.wopi_url = "https://office.example.com";

      maxUploadSize = "4G";

      hostName = cfg.hostname;
      https = true;
    };

    services.nginx.virtualHosts.${cfg.hostname} = {
      forceSSL = true;
      enableACME = true;
    };

    # Настройка Nginx для Collabora
    services.nginx.virtualHosts."oo.alexdeb.ru" = {
      forceSSL = true;
      enableACME = true;
      # Проксирование запросов к локальному серверу Collabora (порт по умолчанию 9980)
      locations."/" = {
        proxyPass = "http://127.0.0.1:9980";
        proxyWebsockets = true;
      };
    };

    services.collabora-online = {
      enable = true;
      # Ограничение доступа только для вашего экземпляра Nextcloud
      settings.storage.wopi.host = "nxoo.alexdeb.ru";
    };
    /*
    security.acme = {
      acceptTerms = true;
      certs = {
        ${cfg.hostName} = {
          email = "aj001@mail.ru";
          #domain = "*.${config.services.nextcloud.hostName}";
          #domain = cfg.hostName;
          #group = config.services.nginx.group;
          #extraDomainNames = [cfg.hostName];
        };
      };
    };
    */
  };
}
