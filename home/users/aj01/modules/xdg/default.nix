{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.user.xdg;
in {
  options = {
    module.user.xdg.enable = mkEnableOption "Enables xdg";
  };

  config = mkIf cfg.enable {
    xdg.desktopEntries = {
      browser = {
        exec = "${config.module.defaults.browserCmd} %U";
        genericName = "Browser selector";
        name = "browser";
        type = "Application";
        terminal = false;
      };

      editor = {
        exec = "${config.module.defaults.editorCmd} %U";
        genericName = "Editor selector";
        name = "editor";
        type = "Application";
        terminal = true;
      };
    };
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

        #"application/pdf" = "org.pwmt.zathura.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      };

      /*
        defaultApplications = {
        "text/markdown" = "editor.desktop";
        "text/plain" = "editor.desktop";
        "text/x-python" = "editor.desktop";

        "text/html" = "browser.desktop";
        "x-scheme-handler/http" = "browser.desktop";
        "x-scheme-handler/https" = "browser.desktop";
        "x-scheme-handler/about" = "browser.desktop";
        "x-scheme-handler/unknown" = "browser.desktop";

        "image/png" = "org.gnome.eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/jpg" = "org.gnome.eog.desktop";
        "image/svg" = "org.gnome.eog.desktop";

        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
      };
      */
    };
  };
}
