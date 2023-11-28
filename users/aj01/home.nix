# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    # impermanence
    inputs.impermanence.nixosModules.home-manager.impermanence
    #(inputs.impermanence + "/home-manager.nix")

    # Mutability (VSCode error saving settings)
    # See https://github.com/nix-community/home-manager/issues/1800#issuecomment-1633095126
    ./mutability.nix

    # Apps
    # ./applications/hyprland.nix
    ./applications/sway.nix
    ./applications/waybar.nix
    ./applications/stylix.nix

    ./applications/eww
    ./applications/anyrun.nix
    ./applications/foot.nix

    ./applications/vscode/vscode-files.nix
    ./applications/vscode/vscode.nix
    ./applications/firefox
    ./applications/mpd.nix
    ./applications/starship.nix

    #./applications/qt.nix
  ];

  # Can be used if allowGlobalPackages is false
  #nixpkgs = {
  #  # You can add overlays here
  #  overlays = [
  #    # If you want to use overlays exported from other flakes:
  #    # neovim-nightly-overlay.overlays.default
  #
  #    # Or define it inline, for example:
  #    # (final: prev: {
  #    #   hi = final.hello.overrideAttrs (oldAttrs: {
  #    #     patches = [ ./change-hello-to-hi.patch ];
  #    #   });
  #    # })
  #  ];
  #  # Configure your nixpkgs instance
  #  config = {
  #    # Disable if you don't want unfree packages
  #    allowUnfree = true;
  #    # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #    allowUnfreePredicate = _: true;
  #  };
  #};

  /*
  home.pointerCursor = {
    #package = pkgs.catppuccin-cursors.mochaPeach;
    #name = "Catppuccin-Mocha-Peach-Cursors";
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
    gtk.enable = true;
  };
  */

  # set cursor size and dpi for 4k monitor
  /*
    xresources.properties = {
    "Xcursor.size" = 16;
    #"Xft.dpi" = 172;
  };
  */

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
  /*
  gtk = {
    enable = true;
    font = {
      package = pkgs.nerdfonts.override {fonts = ["Mononoki"];};
      #name = "Mononoki Nerd Font Regular";
      name = "Noto Sans";
      size = 12;
    };
    iconTheme = {
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "peach";
      };
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["peach"];
        size = "standard";
        variant = "mocha";
      };
      name = "Catppuccin-Mocha-Standard-Peach-Dark";
    };
  };
  */

  #programs.virt-manager.enable = true;
  dconf = {
    enable = true;

    settings = {
      # Virt-manager settings.
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };

      /*
        # UI settings handled by stylix.
        "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      */
    };
  };

  /*
  qt = {
    enable = true;
    #Platform theme can has value: "gtk", "gnome", "qtct", "kde" or null
    platformTheme = "qtct";
    style = {
      package = lib.mkForce pkgs.catppuccin-kvantum;
      name = lib.mkForce "kvantum";
    };
  };
  */
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = lib.mkForce "kvantum-dark";
      #name = "kvantum-dark";
      package = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
      ];
    };
  };

  home = {
    username = "aj01";
    homeDirectory = "/home/aj01";

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    packages = with pkgs; [
      git
      socat
      curl
      wget
      dos2unix
      proxychains-ng

      # tui
      htop
      btop
      mc
      neofetch
      iftop

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb

      # wayland stuff
      grim
      slurp
      swaybg
      eww-wayland
      wl-clipboard
      hyprpicker
      wlogout
      playerctl
      waybar
      mako
      foot
      swaylock
      swayidle
      wofi
      swayest-workstyle

      eza
      nil

      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "slab";})
      iosevka-bin

      mangohud
      intel-gpu-tools
      pavucontrol
      udisks2
      ffmpeg

      # general software
      meld
      vlc
      gimp
      inkscape
      audacity
      remmina
      avalonia-ilspy
      mpv
      #obs-studio
      imv
      wf-recorder
      telegram-desktop
      keepassxc
      thunderbird
      qbittorrent
      teamspeak_client
      winbox
      libreoffice-fresh
      anydesk

      # dotnet-sdk
      # dotnet-sdk_7
      dotnet-sdk_8
      _7zz

      # Qt
      (catppuccin-kvantum.override {
        accent = "Mauve";
        variant = "Mocha";
      })

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
    ];

    # New: Now we can use the "home.persistence" module, here's an example:
    persistence."/nix/persist/home/aj01" = {
      /*
        directories = [
        "Загрузки"
        "Документы"
        "Музыка"
        "Изображения"
        "Видео"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".local/share/wallpapers"
        ".local/share/TelegramDesktop/tdata" # telegram
        "Downloads"
        ".config/dconf"
        #"aj-nixos-config"
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
      files = [
        ".bash_history"
        ".zsh_history"
        # If .zshrc is in persistence then oh-my-zsh don't apply config
        #      ".zshrc"
        # If .config/dconf/user is in persistence then gnome does not saving settings
        #      ".config/dconf/user"
        ".config/gnome-initial-setup-done"
      ];
      */
      allowOther = true; # Useful for sudo operations
    };

    sessionPath = [];

    sessionVariables = {
      BROWSER = "firefox";

      # TODO: init env vars in hyprland config
      # QT_QPA_PLATFORMTHEME = "qt5ct";
      # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # QT_QPA_PLATFORM = "wayland";
      # QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      # XCURSOR_SIZE = "32";
      # XCURSOR_THEME = "Adwaita";
      # NIXOS_OZONE_WL = "1";

      # MOZ_USE_XINPUT2 = "1";
      # MOZ_ENABLE_WAYLAND = "1";
      # MOZ_WEBRENDER = "1";
      # MOZ_ACCELERATED = "1";

      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      XKB_DEFAULT_LAYOUT = "us";
      LIBSEAT_BACKEND = "logind";

      # CLUTTER_BACKEND = "wayland";
      # SDL_VIDEODRIVER = "wayland";

      # _JAVA_AWT_WM_NONREPARENTING = "1";
      # GDK_BACKEND = "wayland";

      #DOTNET_ROOT = "${pkgs.dotnet-sdk}";
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Alexey Debelov";
    userEmail = "alienjustmail@gmail.com";
    extraConfig = {
      http = {
        "https://188.226.43.56:62328" = {
          sslCAInfo = "/home/aj01/gitea.crt";
        };
        "https://192.168.11.20:50589" = {
          sslCAInfo = "/home/aj01/gitlab.crt";
        };
      };
    };
  };

  # direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # fzf
  programs.fzf = {enable = true;};

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
  };

  programs.imv.enable = true;

  programs.mpv = {
    enable = true;
    #scripts = [pkgs.mpvScripts.mpris];
    bindings = {
      ENTER = "playlist-next force";
      WHEEL_UP = "seek 10";
      WHEEL_DOWN = "seek -10";
      "Alt+0" = "set window-scale 0.5";
    };
    defaultProfiles = ["gpu-hq"];
    config = {
      fullscreen = false;
      sub-auto = "fuzzy";

      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      sub-font = "Iosevka";

      # https://github.com/mpv-player/mpv/issues/8981
      hdr-compute-peak = false;

      # https://github.com/mpv-player/mpv/issues/10972#issuecomment-1340100762
      vd-lavc-dr = false;
    };
    profiles = {
      /*
        alsa-mm1 = {
        profile-desc = "Sound via alsa interface: MM-1";
        profile = "gpu-hq";
        audio-device = "alsa/iec958:CARD=MM1,DEV=0";
      };
      alsa-x = {
        profile-desc = "Sound via alsa interface: X";
        profile = "gpu-hq";
        audio-device = "alsa/iec958:CARD=X,DEV=0";
      };
      alsa-hdmi = {
        profile-desc = "Sound via alsa interface: HDMI";
        profile = "gpu-hq";
        audio-device = "alsa/hdmi:CARD=PCH,DEV=0";
      };
      */
      "extension.mkv" = {
        keep-open = true;
        volume-max = "150";
      };
      "extension.mp4" = {
        keep-open = true;
        volume-max = "150";
      };
      "extension.gif" = {
        osc = "no";
        loop-file = true;
      };
      "protocol.dvd" = {
        profile-desc = "profile for dvd:// streams";
        alang = "en";
      };
    };
  };

  services.mako.enable = true;

  #programs.obs-studio = {
  #enable = true;
  #plugins = [pkgs.obs-studio-plugins.wlrobs];
  #};

  programs.helix.enable = true;

  # https://git.sr.ht/~fd/nix-configs/tree/main/item/home/common/wayland/theme.nix
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig" = {
      enable = true;
      text = ''
        [General]
        theme=KvArcDark
      '';
    };
    "Kvantum/KvArcDark#/KvArcDark#.kvconfig" = {
      enable = true;
      source = ./KvArcDark.kvconfig;
    };
  };

  /*
  # xdg defaults
  xdg = {
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/Документы";
      download = "${config.home.homeDirectory}/Загрузки";
      music = "${config.home.homeDirectory}/Музыка";
      pictures = "${config.home.homeDirectory}/Изображения";
      videos = "${config.home.homeDirectory}/Видео";
    };
  };
  */

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
