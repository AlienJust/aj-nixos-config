{
  self,
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.hpb;
  hpb = pkgs.callPackage "${self}/pkgs/hpb" {};
in {
  options = {
    module.hpb.enable = mkEnableOption "Enables HPB";
  };
  config = mkIf cfg.enable {
    /*
    nix.settings = {
      access-tokens = "${builtins.readFile ./gitlab-token}";
    };
    */
    networking.nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "br0";
      # Lazy IPv6 connectivity for the container
    };
    networking.extraHosts = lib.mkAfter ''
      192.168.100.11 hpb.dev.horizont.local
    '';
    containers.hpb4 = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        environment.systemPackages = [pkgs.adminer];
        services.httpd = {
          enable = true;
          enablePHP = true;
          phpOptions = ''
            post_max_size = 20M
            upload_max_filesize = 20M
            memory_limit = 1G
            error_reporting = E_ALL & ~E_WARNING & ~E_NOTICE
            display_errors = Off
          '';
          phpPackage = pkgs.php84;
          adminAddr = "root@localhost";
          # documentRoot = "${pkgs.hpb}/index.php";
          # documentRoot = "/var/www";
          # listen = [ { ip = "127.0.0.1"; port = 80; } ];
          virtualHosts = {
            "hpb.dev.horizont.local" = {
              listen = [
                {
                  ip = "192.168.100.11";
                  port = 80;
                }
              ];
              documentRoot = "${hpb}/www";
              #documentRoot = "${spoofdpi}/index.php";
              extraConfig = ''
                DirectoryIndex index.php

                Alias /adminer "${pkgs.adminer}/adminer.php"
                <Files "${pkgs.adminer}/adminer.php">
                  Require all granted
                  SetHandler lbphp-handler
                </Files>
              '';
            };
          };
          extraConfig = ''
            <Directory /var/www>
              Options Indexes FollowSymLinks MultiViews
              AllowOverride All
              Order allow,deny
              allow from all
            </Directory>
          '';
        };
        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          initialScript = pkgs.writeText "initial-script" ''
            --CREATE DATABASE IF NOT EXISTS wordpress;
            --source ${hpb}/.dump/hpb.sql;
            CREATE USER IF NOT EXISTS 'horizon'@'localhost' IDENTIFIED BY 'ftjwTkqKHCo1Rk8bJu';
            --GRANT ALL PRIVILEGES ON hpb.* TO 'horizon'@'localhost';
          '';
          initialDatabases = [
            {
              name = "hpb";
              schema = "${hpb}/.dump/hpb.sql";
            }
          ];
          configFile = pkgs.writeText "mysql.conf" ''
            # [mariadb]
            # unix_socket=OFF
            # unix_socket=OFF
            # [client]
            # user=pdns
            # password=teleport
            [mysql]
            # unix_socket=OFF
            # database = hpb
             port = 3306
             socket = /run/mysqld/mysqld.sock
          '';
          ensureDatabases = ["hpb"];
          ensureUsers = [
            {
              # Will be createrd 'horizon'@'localhost' if not exists
              name = "horizon";
              ensurePermissions = {
                "hpb.*" = "ALL PRIVILEGES";
              };
            }
          ];
        };
        system.stateVersion = "24.11";
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [80];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;
      virtualHosts = {
        default = {
          serverName = "_";
          default = true;
          rejectSSL = true;
          locations."/".return = "444";
        };
        "hpb.dev.horizont.local" = {
          serverName = "hpb.dev.horizont.local";
          forceSSL = false;
          locations."/" = {
            recommendedProxySettings = true;
            proxyPass = "http://hpb.dev.horizont.local:80";
          };
        };
      };
    };
  };
}
