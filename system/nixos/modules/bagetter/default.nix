{
  self,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.bagetter;
  bagetter = pkgs.callPackage "${self}/pkgs/bagetter" {};
in {
  options.module.bagetter = {
    enable = mkEnableOption "Enables bagetter";
    hostname = mkOption {
      type = types.str;
      description = "Bagetter hostname";
      default = "";
    };
    package = mkOption {
      type = types.package;
      #default = pkgs.bagetter;
      default = bagetter;
      defaultText = literalExpression "pkgs.bagetter";
      description = "The package to use";
    };
  };
  config = mkIf cfg.enable {
    # services.bagetter.enable = true;
    systemd.services.bagetter = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        Restart = "always";
        WorkingDirectory = "${cfg.package}/bin";
        ExecStart = ''
          ${lib.getExe cfg.package}
        '';
        # DynamicUser = "yes";

        preStart = ''
          mkdir -p /var/bagetter
        '';
      };
    };

    security.acme = {
      acceptTerms = true;
      certs = {
        ${cfg.hostname}.email = "aj001@mail.ru";
      };
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
