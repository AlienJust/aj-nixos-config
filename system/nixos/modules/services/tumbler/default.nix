{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.tumbler;
in {
  options = {
    module.services.tumbler.enable = mkEnableOption "Enable tumbler";
  };

  config = mkIf cfg.enable {
    services.tumbler.enable = true; # Mount, trash, and other functionalities
  };
}
