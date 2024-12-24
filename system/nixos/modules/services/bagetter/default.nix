{
  self,
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.module.services.bagetter;
  bagetter = pkgs.callPackage "${self}/pkgs/bagetter" {};
  #bagetter = pkgs.bagetter;
in {
  options.module.services.bagetter = {
    enable = mkEnableOption "bagetter service";

    package = mkOption {
      type = types.package;
      #default = pkgs.bagetter;
      default = bagetter;
      defaultText = literalExpression "pkgs.bagetter";
      description = "The package to use.";
    };
  };

  config = mkIf cfg.enable {
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
  };
}
