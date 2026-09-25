{
  pkgs,
  lib,
  config,
  wm,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.programs.xdg-portal;
in {
  options = {
    module.programs.xdg-portal.enable = mkEnableOption "Enable xdg-portal";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;

      config = {
        common = {
          # Вместо "*" лучше явно указать дефолты или ограничить "gtk" для файлов
          default = "*";

          # Явно заставляем файловый менеджер использовать GTK-портал
          "org.freedesktop.impl.portal.FileChooser" = "gtk";

          "org.freedesktop.impl.portal.Screencast" = wm;
          "org.freedesktop.impl.portal.Screenshot" = wm;
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        # xdg-desktop-portal-gnome
      ];
    };
  };
}
