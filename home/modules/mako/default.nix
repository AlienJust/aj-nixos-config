{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.mako;
in {
  options = {
    module.mako.enable = mkEnableOption "Enables mako";
  };

  config = mkIf cfg.enable {
    programs.mako = {
      enable = true;
    };
  };
}
