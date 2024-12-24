{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.fstrim;
in {
  options = {
    module.services.fstrim.enable = mkEnableOption "Enable fstrim";
  };

  config = mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}


