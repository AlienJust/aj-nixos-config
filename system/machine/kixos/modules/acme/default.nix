{
  config,
  inputs,
  pkgs,
  ...
}: {
  ## TODO fix when lego in stable v4.20.0+
  #nixpkgs.overlays = [(_: _: {lego = inputs.unstable.legacyPackages.${pkgs.system}.lego.override {};})];

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "aj001@mail.ru";
      group = "nginx";
    };

    certs = {
      "alexdeb.ru" = {
        extraDomainNames = ["*.alexdeb.ru"];
        #dnsProvider = "timewebcloud";
        #credentialsFile = config.sops.secrets."dns/token".path;
        webroot = null;
      };
    };
  };
}
