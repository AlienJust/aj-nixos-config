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
    module.nextcloud.hostname = mkStringOption "Nextcloud hostname";
  };
  config = mkIf cfg.enable {
    environment.etc."nextcloud-admin-pass".text = "1234567890";
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
