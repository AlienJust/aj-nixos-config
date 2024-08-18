{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.module.xdg;
in {
  options = {
    module.xdg.enable = mkEnableOption "Enables xdg";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      enable = true;

      defaultApplications = {
        "text/markdown" = "nvim.desktop";
        "text/plain" = "nvim.desktop";

        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        "image/png" = "org.eog.desktop";
        "image/jpeg" = "org.eog.desktop";
        "image/jpg" = "org.eog.desktop";

        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
}
