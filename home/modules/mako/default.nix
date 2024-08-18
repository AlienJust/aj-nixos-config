{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.mako;
in {
  options = {
    module.Mako.enable = mkEnableOption "Enables Mako";
  };

  config = mkIf cfg.enable {
    programs.mako = {
      enable = true;
    };
  };
}
