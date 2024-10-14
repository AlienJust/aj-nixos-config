{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.stylix;
in {
  options = {
    module.stylix.enable = mkEnableOption "Enables stylix";
  };

  config = mkIf cfg.enable {
    # TODO: remove when bug fixed: https://github.com/danth/stylix/issues/480
    stylix.targets.kde.enable = false;

    stylix = {
      enable = true;
      autoEnable = true;
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

      base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml"; # nice
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-light.yaml"; # nice

      #base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/material-darker.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/materia.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-dark.yaml"; #nice
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/evenok-dark.yaml"; #nice black
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml"; #nice
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/synth-midnight-dark.yaml"; #nice black
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night-eighties.yaml"; #nice warm scheme
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/tango.yaml"; #sane defaul warm scheme
      #base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml"; #nice

      cursor = {
        package = pkgs.catppuccin-cursors.mochaPeach;
        #name = "Catppuccin-Mocha-Peach-Cursors";
        name = "catppuccin-mocha-peach-cursors";
        #name = "CatppuccinMochaPeachCursors";
        #package = pkgs.capitaine-cursors;
        #name = "capitaine-cursors";
        size = 32;
      };

      /*
      image = pkgs.fetchurl {
        url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-dracula.png";
        sha256 = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
      };
      */

      /*
      fonts = {
        monospace = {
          package = pkgs.nerdfonts;
          name = "hack nerd font mono";
        };

        sizes = {
          terminal = 12;
        };
      };
      */

      # https://www.reddit.com/r/NixOS/comments/3jqd2u/anyone_want_a_wallpaper/
      # also check: https://github.com/NixOS/nixos-artwork/tree/master/wallpapers
      # image = pkgs.fetchurl {
      #   url = "http://reign-studios.com/wallpapers/nixos/wallpaper.svg";
      #   sha256 = "sha256-vXbw39v0sA+aR/9Gg0NOPgL3QHuw0Wl+ACbn9VJ8Fyg=";
      # };

      # image = pkgs.fetchurl {
      #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
      #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
      # };

      # image = ../../../wall3.png;
      image = ../../../wall.jpg;
      # image = ../../../wall2.jpg;

      #image = pkgs.fetchurl {
      #  url = "https://cdnb.artstation.com/p/assets/images/images/016/252/301/4k/grady-frederick-atlantis-garbageman-v2.jpg";
      #  sha256 = "tAX6qTm1/7v/auvCHrmRswJsScNieSWpXV6TCBhRP7Y=";
      #};

      fonts = {
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

        /*
          monospace = {
          package = pkgs.iosevka-bin.override {variant = "SGr-IosevkaTerm";}; # unstable
          name = "Iosevka Term";
        };
        */

        monospace = {
          package = pkgs.nerdfonts.override {fonts = ["UbuntuMono" "JetBrainsMono" "Iosevka"];};
          name = "Iosevka Nerd Font Mono";
        };

        emoji = {
          name = "OpenMoji Color";
          package = pkgs.openmoji-color;
        };

        sizes = {
          desktop = 9; #10;
          applications = 9; #10;
          terminal = 11; #12;
          popups = 9;
        };
      };

      opacity = {
        terminal = 0.9;
        popups = 0.9;
      };

      polarity = "dark";
      # polarity = "light";
    };
  };
}
