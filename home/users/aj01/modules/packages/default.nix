{
  config,
  lib,
  pkgs,
  inputs,
  isWorkstation,
  wmEnable,
  ...
}:
with lib; let
  inherit (pkgs.stdenv) isLinux;
  cfg = config.module.user.packages;
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

        # Security
        age
        sops
      ]
      ++ lib.optionals isWorkstation [
        # Text Editors
        obsidian

        # Security
        semgrep
        grype
        syft

        # Fonts
        (nerdfonts.override {fonts = ["JetBrainsMono" "UbuntuMono" "Iosevka"];})
        corefonts
      ]
      ++ lib.optionals (isLinux && isWorkstation) [
        # Programming
        go
        python3

        # DevOps Utils
        docker-compose
        kubectl
        kubernetes-helm
        ansible
        ansible-lint
        terraform
        vagrant

        # Chats
        telegram-desktop
        vesktop

        # Office
        onlyoffice-bin

        # Misc
        obs-studio
        dconf2nix
        via
        gpick
        gat
        vlc
        eog

        mangohud
        #intel-gpu-tools
        pavucontrol

        udisks2
        ffmpeg
        cava
        sacd
        _7zz
        mc

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
        #obs-studio
        imv
        wf-recorder
        keepassxc
        thunderbird
        qbittorrent
        teamspeak_client
        winbox
        libreoffice-fresh
        # anydesk
        # chromium
        krita
        xfce.mousepad
      ]
      ++ lib.optionals wmEnable [
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
