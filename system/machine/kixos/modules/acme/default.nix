{
  config,
  inputs,
  pkgs,
  ...
}: {
  ## TODO fix when lego in stable v4.20.0+
  #nixpkgs.overlays = [(_: _: {lego = inputs.unstable.legacyPackages.${pkgs.system}.lego.override {};})];
  users.users.nginx.extraGroups = ["acme"];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "alexdeb.ru" = {
        # Catchall vhost, will redirect users to HTTPS for all vhosts
        serverAliases = ["*.alexdeb.ru"];
        locations."/.well-known/acme-challenge" = {
          root = "/var/lib/acme/.challenges";
        };
        locations."/" = {
          return = "301 https://$host$request_uri";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "aj001@mail.ru";
      group = "nginx";
    };

    certs = {
      "alexdeb.ru" = {
        webroot = "/var/lib/acme/.challenges";
        extraDomainNames = ["*.alexdeb.ru"];
        #dnsProvider = "timewebcloud";
        #credentialsFile = config.sops.secrets."dns/token".path;
        #webroot = null;
      };
    };
  };
}
