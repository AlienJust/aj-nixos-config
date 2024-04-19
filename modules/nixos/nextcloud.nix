{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    nginx.virtualHosts = {
      "horizoncloud.alxedeb.ru" = {
        forceSSL = true;
        enableACME = true;
      };

      "horizonoffice.alexdeb.ru" = {
        forceSSL = true;
        enableACME = true;
      };
    };

    nextcloud = {
      enable = true;
      hostName = "horizoncloud.alxedeb.ru";

      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud28;

      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "2G";
      https = true;
      enableBrokenCiphersForSSE = false;

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts mail notes onlyoffice tasks;

        # Custom app installation example.
        cookbook = pkgs.fetchNextcloudApp rec {
          url = "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
          sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        };
      };

      environment.etc."nextcloud-admin-pass".text = "1234567890";
      config = {
        overwriteProtocol = "https";
        defaultPhoneRegion = "PT";
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/etc/nextcloud-admin-pass";
      };
    };

    onlyoffice = {
      enable = true;
      hostname = "horizonoffice.alexdeb.ru";
    };
  };
}
