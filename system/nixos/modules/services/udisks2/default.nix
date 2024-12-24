{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.udisks2;
in {
  options = {
    module.services.udisks2.enable = mkEnableOption "Enable udisks2";
  };

  config = mkIf cfg.enable {
    services.udisks2.enable = true; # Mount, trash, and other functionalities
  };
}
