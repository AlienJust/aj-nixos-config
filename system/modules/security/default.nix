{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.security;
in {
  options = {
    module.security.enable = mkEnableOption "Enables security";
  };

  config = mkIf cfg.enable {
    # environment.memoryAllocator.provider = "graphene-hardened";

    security = {
      sudo.enable = true;
      sudo.wheelNeedsPassword = false;

      pam.services.swaylock = {};

      doas = {
        enable = true;
        extraRules = [
          {
            groups = ["wheel"];
            noPass = true;
            keepEnv = true;
            persist = true;
          }
        ];
      };
    };
  };
}
