{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.module.gtk;
in {
  options = {
    module.gtk.enable = mkEnableOption "Enables gtk";
  };

  config = mkIf cfg.enable {
    gtk = {
      #enalbe = true;
      iconTheme = {
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "peach";
        };
        name = "Papirus-Dark";
      };
    };
  };
}
