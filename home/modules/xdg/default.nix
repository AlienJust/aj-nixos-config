{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.xdg;
in {
  options = {
    module.xdg.enable = mkEnableOption "Enables xdg";
  };
  # https://nxoo.alexdeb.ru
  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      /*
      associations.added = {
        #"application/pdf" = ["org.gnome.Evince.desktop"];
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
      */
      # TODO: To make this work need to be executed:
      # TODO: systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service
      defaultApplications = {
        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";

        "default-web-browser" = ["firefox.desktop"];
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/about" = ["firefox.desktop"];
        "x-scheme-handler/unknown" = ["firefox.desktop"];

        "image/png" = "org.eog.desktop";
        "image/jpeg" = "org.eog.desktop";
        "image/jpg" = "org.eog.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
}
