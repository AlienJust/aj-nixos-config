{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.devmon;
in {
  options = {
    module.services.devmon.enable = mkEnableOption "Enable devmon";
  };

  config = mkIf cfg.enable {
    services.devmon.enable = true; # Mount, trash, and other functionalities
  };
}
