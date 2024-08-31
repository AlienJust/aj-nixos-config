{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.thumbler;
in {
  options = {
    module.services.thumbler.enable = mkEnableOption "Enable thumbler";
  };

  config = mkIf cfg.enable {
    services.thumbler.enable = true; # Mount, trash, and other functionalities
  };
}
