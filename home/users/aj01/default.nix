{
  self,
  lib,
  pkgs,
  inputs,
  config,
  generalModules,
  homeModules,
  isWorkstation,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  ufetch = pkgs.callPackage "${self}/pkgs/ufetch" {};
  sshModule = "${homeModules}/ssh";
  sshModuleExist = builtins.pathExists sshModule;
in {
  imports =
    [
      "${generalModules}"
      "${homeModules}"

      # for vscode settings r/w
      ./mutability.nix
    ]
    ++ lib.optional sshModuleExist sshModule;

  nixpkgs.overlays = [
    # (import "${self}/home/overlays/rofi-calc")
    # (import "${self}/home/overlays/rofi-emoji")
  ];

  /*
  stylix.targets = {
    #vscode.enable = false;
    helix.enable = false;
  };
  */

  module = {
    alacritty.enable = isWorkstation;
    vscode.enable = isWorkstation;
    doom-emacs.enable = isWorkstation;
    zathura.enable = isWorkstation;

    chrome.enable = isLinux && isWorkstation;
    firefox.enable = isLinux && isWorkstation;
    foot.enable = isLinux && isWorkstation;
    ssh.enable = isLinux && isWorkstation;
    hyprland.enable = isLinux && isWorkstation;
    sway.enable = isLinux && isWorkstation;

    impermanence.enable = isLinux && isWorkstation;
    xdg.enable = isLinux && isWorkstation;

    stylix.enable = isLinux && isWorkstation;
    kde-theme.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;

    hypridle.enable = config.module.hyprland.enable;
    hyprlock.enable = config.module.hyprland.enable;
    waybar.enable = config.module.hyprland.enable;
    rofi.enable = config.module.hyprland.enable;
    swaync.enable = config.module.hyprland.enable;

    swaylock.enable = config.module.sway.enable;
    wlogout.enable = config.module.sway.enable;
    #mako.enable = false; #config.module.sway.enable;

    mpd.enable = isLinux && isWorkstation;
    mpv.enable = isLinux && isWorkstation;

    btop.enable = true;
    eza.enable = true;
    git.enable = true;
    direnv.enable = true;
    fzf.enable = true;
    htop.enable = true;
    ripgrep.enable = true;
    neofetch.enable = true;
    nvim.enable = true;
    helix.enable = true;
    password-store.enable = true;
    zsh.enable = true;
    fish.enable = true;
    zoxide.enable = true;
    yazi.enable = true;
  };

  home = {
    # Software
    packages = with pkgs;
      [
        # Utils
        bat
        tokei
        shellcheck
        pre-commit
        deadnix
        statix
        # eza
        ffmpeg
        inputs.any-nix-shell

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

        # Security
        age
        sops
        grype
        syft
      ]
      ++ lib.optionals isWorkstation [
        # Chats
        discord

        # Text Editors
        obsidian

        # Security
        semgrep
      ]
      ++ lib.optionals (isLinux && isWorkstation) [
        # Local
        ufetch

        # DevOps Utils
        vagrant

        # Chats
        telegram-desktop
        vesktop

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

        # Virt
        bridge-utils
        qemu
        swtpm
        edk2
        OVMF
        virt-manager
        virt-viewer
        spice
        spice-gtk
        spice-protocol
        win-virtio
        win-spice

        # native wayland support (unstable)
        wineWowPackages.waylandFull
        cabextract
      ];
  };
}
