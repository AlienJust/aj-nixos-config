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
    qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = lib.mkForce "kvantum-dark";
      #name = "kvantum-dark";
      package = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
      ];
    };
  };

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
