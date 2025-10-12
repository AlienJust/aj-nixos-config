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

    environment.etc."nextcloud-admin-pass".text = config.sops.secrets.nextcloud_admin_pass.path;
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      config.adminpassFile = "/etc/nextcloud-admin-pass";

      config.dbtype = "sqlite";

      configureRedis = true;

      extraAppsEnable = true;
      maxUploadSize = "4G";

      hostName = cfg.hostname;
      https = true;
    };

    services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      enableACME = true;
    };

    security.acme = {
      acceptTerms = true;
      certs = {
        ${config.services.nextcloud.hostName}.email = "aj001@mail.ru";
      };
    };
  };
}
