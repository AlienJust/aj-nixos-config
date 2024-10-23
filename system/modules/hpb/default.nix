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
    #services.netbird.enable = true;
    #environment.systemPackages = [pkgs.netbird-ui];

    #ystemd.services.NetworkManager-wait-online.enable = false;
    networking.nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "br0";
      # Lazy IPv6 connectivity for the container
    };

    containers.hpb = {
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
        services.httpd = {
          enable = true;
          enablePHP = true;
          phpOptions = ''
            post_max_size = 20M
            upload_max_filesize = 20M
          '';
          phpPackage = pkgs.php;
          adminAddr = "root@localhost";
          # documentRoot = "${pkgs.hpb}/index.php";
          # documentRoot = "/var/www";
          # listen = [ { ip = "127.0.0.1"; port = 80; } ];
          virtualHosts = {
            "hpb.dev.local" = {
              listen = [
                {
                  ip = "127.0.0.1";
                  port = 80;
                }
              ];
              # documentRoot = "/var/www/esther-loeffel";
              documentRoot = "${hpb}/index.php";
              #documentRoot = "${spoofdpi}/index.php";
              extraConfig = ''
                DirectoryIndex index.php
              '';
            };
            /*
            "gartenforst.dev.local" = {
              listen = [
                {
                  ip = "127.0.0.1";
                  port = 80;
                }
              ];
              documentRoot = "/var/www/gartenforst";
              extraConfig = ''
                DirectoryIndex index.php
              '';
            };
            */

            # {
            # listen = [ { ip = "127.0.0.1"; port = 80; } ];
            # hostName = "esther-loeffel-before-upgrade.dev.local";
            # documentRoot = "/var/www/esther-loeffel-before-upgrade";
            # extraConfig = ''
            # DirectoryIndex index.php
            # '';
            # }

            /*
            "baukombinat.dev.local" = {
              listen = [
                {
                  ip = "127.0.0.1";
                  port = 80;
                }
              ];
              documentRoot = "/var/www/baukombinat";
              extraConfig = ''
                DirectoryIndex index.php
              '';
            };
            */
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
  };
}
