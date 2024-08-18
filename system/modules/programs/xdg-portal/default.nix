{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.programs.xdg-portal;
in {
  options = {
    module.programs.xdg-portal.enable = mkEnableOption "Enable xdg-portal";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;

      config = {
        common = {
          default = "*";

          "org.freedesktop.impl.portal.Screencast" = "hyprland";
          "org.freedesktop.impl.portal.Screenshot" = "hyprland";

          #"org.freedesktop.impl.portal.Screencast" = "sway";
          #"org.freedesktop.impl.portal.Screenshot" = "sway";
        };
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
