{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.module.fonts;
in {
  options = {
    module.fonts.enable = mkEnableOption "Enables fonts";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fontconfig
    ];
    fonts = {
      /*
        packages = with pkgs; [
        (nerdfonts.override {fonts = ["Iosevka" "Hack" "FiraCode" "DroidSansMono"];})
        iosevka-bin

        hack-font

        fira-code
        fira-code-symbols

        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif

        noto-fonts-emoji
        noto-fonts-monochrome-emoji
        openmoji-color

        maple-mono-NF
        (pkgs.callPackage ../../pkgs/mplus-fonts {}) # TODO: do I really need to call it like this?
        (pkgs.callPackage ../../pkgs/balsamiqsans {})
      ];
      */
      /*
      fontconfig = {
        enable = lib.mkDefault true;
        defaultFonts = {
          #monospace = ["M PLUS 1 Code"];
          monospace = ["Iosevka Term"];

          #emoji = ["Noto Color Emoji"];
          emoji = ["OpenMoji Color"];
        };
      };
      */
      fontDir.enable = true;
    };
  };
}
