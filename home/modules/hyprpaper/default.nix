{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.hyprpaper;
in {
  options = {
    module.hyprpaper.enable = mkEnableOption "Enables hyprpaper";
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;

      settings = {
        preload = ["../../../wall.jpg"];
        wallpapers = ["../../../wall.jpg"];
      };
    };
  };
}
