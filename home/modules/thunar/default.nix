{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.thunar;
in {
  options = {
    module.thunar.enable = mkEnableOption "Enables thunar";
  };

  config = mkIf cfg.enable {
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
