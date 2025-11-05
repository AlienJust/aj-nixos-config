{
  self,
  config,
  lib,
  pkgs,
  inputs,
  isWorkstation,
  wmEnable,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optionals;
  inherit (pkgs.stdenv) isLinux;
  cfg = config.module.user.packages;
  sfp = pkgs.callPackage "${self}/pkgs/sfp" {};
in {
  options.module.user.packages = {
    enable = mkEnableOption "Enable user packages";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs;
      [
        # Utils
        bat
        tokei
        shellcheck
        pre-commit
        deadnix
        statix
        ffmpeg
        inputs.any-nix-shell
        udisks2
        #cava
        sacd
        _7zz
        mc
        yt-dlp

        # Security
        age
        sops
      ]
      ++ optionals isWorkstation [
        # Security
        semgrep
        grype
        syft

        # Fonts
        #(nerdfonts.override {fonts = ["JetBrainsMono" "UbuntuMono" "Iosevka"];})
        corefonts
      ]
      ++ optionals (isLinux && isWorkstation) [
        # Programming
        #go
        #python3

        # DevOps Utils
        docker-compose
        #kubectl
        #kubernetes-helm
        #ansible
        #ansible-lint
        #terraform
        #vagrant

        # Chats
        telegram-desktop
        #vesktop

        # Office
        #onlyoffice-bin
        libreoffice-fresh

        # Misc
        dconf2nix
        via
        # gpick
        gat
        vlc
        eog

        mangohud
        #intel-gpu-tools

        # general software
        meld
        vlc
        gimp
        inkscape
        #audacity
        remmina
        galculator
        avalonia-ilspy
        mpv
        obs-studio
        imv
        wf-recorder
        keepassxc
        thunderbird
        qbittorrent
        #teamspeak_client
        winbox

        # anydesk
        # chromium
        krita
        xfce.mousepad

        # yandex-music

        # games
        clonehero
        shattered-pixel-dungeon
        luanti
        # openarena

        sfp
      ]
      ++ optionals wmEnable [
        imagemagick
        grim
        slurp
        wl-clipboard
        wf-recorder
        hyprpicker
        waypaper
        cliphist
        imv
        gtk3
        dbus
        glib
        swww
        xdg-utils

        pavucontrol

        nemo
        eww
        networkmanagerapplet
        brightnessctl
      ];
  };
}
