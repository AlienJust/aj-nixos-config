{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # stylix
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

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

    opacity = {
      terminal = 0.9;
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

    # image = pkgs.fetchurl {
    #   url = "https://cdnb.artstation.com/p/assets/images/images/016/252/301/4k/grady-frederick-atlantis-garbageman-v2.jpg";
    #   sha256 = "tAX6qTm1/7v/auvCHrmRswJsScNieSWpXV6TCBhRP7Y=";
    # };

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override {variant = "etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "aile";};
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin.override {variant = "sgr-iosevka-term";};
        name = "Iosevka Term";
      };

      emoji = {
        name = "OpenMoji Color";
        package = pkgs.openmoji-color;
      };

      sizes = {
        desktop = 10;
        applications = 12;
        terminal = 14;
      };
    };
  };
}
