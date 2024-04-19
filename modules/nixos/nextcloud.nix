{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  security.acme = {
  acceptTerms = true;
  defaults.email = "aj001@mail.ru";
  /*certs."mx1.example.org" = {
    dnsProvider = "inwx";
    # Supplying password files like this will make your credentials world-readable
    # in the Nix store. This is for demonstration purpose only, do not use this in production.
    environmentFile = "${pkgs.writeText "inwx-creds" ''
      INWX_USERNAME=xxxxxxxxxx
      INWX_PASSWORD=yyyyyyyyyy
    ''}";
  };*/
};
  services = {
    nginx.enable = true;
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
      #enableBrokenCiphersForSSE = false;

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts mail notes onlyoffice tasks;

        # Custom app installation example.
        /*cookbook = pkgs.fetchNextcloudApp rec {
          url = "https://github.com/nextcloud/cookbook/releases/download/v0.10.2/Cookbook-0.10.2.tar.gz";
          sha256 = "sha256-XgBwUr26qW6wvqhrnhhhhcN4wkI+eXDHnNSm1HDbP6M=";
        };*/
      };

      settings.overwriteprotocol = "https";
      settings.default_phone_region = "RU";
      
      config = {
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
  
  environment.etc."nextcloud-admin-pass".text = "1234567890";
}
