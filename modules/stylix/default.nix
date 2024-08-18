{
  pkgs,
  config,
  hostname,
  ...
}: let
  theme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  wallpaper = ./wall.png;
  cursorSize =
    if hostname == "mixos"
    then 32
    else 24;
in {
  stylix = {
    enable = true;
    image = wallpaper;
    autoEnable = true;
    polarity = "dark";

    base16Scheme = theme;

    opacity = {
      applications = 1.0;
      terminal = 1.0;
      popups = 1.0;
      desktop = 1.0;
    };

    cursor = {
      name = "Vimix-cursors";
      package = pkgs.vimix-cursors;
      size = cursorSize;
    };

    fonts = {
      sizes = {
        applications = 11;
        terminal = 11;
        popups = 11;
        desktop = 11;
      };

      /*
      serif = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "Iosevka"];};
        name = "Iosevka Nerd Font Mono";
      };

      sansSerif = config.stylix.fonts.serif;

      monospace = {
        inherit (config.stylix.fonts.serif) package;
        name = "Iosevka Term";
      };

      emoji = config.stylix.fonts.serif;
      */

      serif = {
        package = pkgs.iosevka-bin.override {variant = "Etoile";}; #unstable
        # package = pkgs.iosevka-bin.override {variant = "etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "Aile";}; #unstable
        # package = pkgs.iosevka-bin.override {variant = "aile";};
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin.override {variant = "SGr-IosevkaTerm";}; # unstable
        # package = pkgs.iosevka-bin.override {variant = "sgr-iosevka-term";};
        name = "Iosevka Term";
      };

      emoji = {
        name = "OpenMoji Color";
        package = pkgs.openmoji-color;
      };
    };
  };
}