{
  config,
  pkgs,
  inputs,
  ...
}: {
  # TODO fix when lego in stable v4.20.0+
  nixpkgs.overlays = [(_: _: {lego = inputs.unstable.legacyPackages.${pkgs.system}.lego.override {};})];

  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "muravjev.mak@yandex.ru";
      group = "nginx";
    };

    certs = {
      "ext.maxmur.info" = {
        extraDomainNames = ["*.ext.maxmur.info"];
        dnsProvider = "timewebcloud";
        credentialsFile = config.sops.secrets."dns/token".path;
        webroot = null;
      };
    };
  };
}
