{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.bagetter;
in {
  options = {
    module.bagetter.enable = mkEnableOption "Enables bagetter";
    module.bagetter.hostname = mkStringOption "Bagetter hostname";
  };
  config = mkIf cfg.enable {
    services.bagetter.enable = true;

    security.acme = {
      acceptTerms = true;
      ${cfg.hostname}.email = "aj001@mail.ru";
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts.${cfg.hostname} = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:6580";
          proxyWebsockets = true; # needed if you need to use WebSocket
          extraConfig =
            # required when the target is also TLS server with multiple hosts
            "proxy_ssl_server_name on;"
            +
            # required when the server wants to use HTTP Authentication
            "proxy_pass_header Authorization;";
        };
      };
    };
  };
}
