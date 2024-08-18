{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.kde-theme;
in {
  options = {
    module.kde-theme.enable = mkEnableOption "Enables kde-theme";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "Kvantum/kvantum.kvconfig" = {
        enable = true;
        text = ''
          [General]
          theme=KvArcDark
        '';
      };
      "Kvantum/KvArcDark#/KvArcDark#.kvconfig" = {
        enable = true;
        source = ./KvArcDark.kvconfig;
      };
    };
  };
}
