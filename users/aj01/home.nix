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

    # Apps
    ./applications/hyprland.nix
    ./applications/eww
    ./applications/anyrun.nix
    ./applications/foot.nix

    ./applications/vscode.nix
    ./applications/firefox
    ./applications/mpd.nix
    ./applications/starship.nix
    #./applications/stylix.nix
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

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaPeach;
    name = "Catppuccin-Mocha-Peach-Cursors";
    size = 40;
    gtk.enable = true;
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    #"Xft.dpi" = 172;
  };

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

  home = {
    username = "aj01";
    homeDirectory = "/home/aj01";

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    packages = with pkgs; [
      dconf
      git
      socat
      curl
      wget

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
      sway
      foot
      swaylock
      swayidle

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
      telegram-desktop
      keepassxc
      thunderbird

      # dotnet-sdk
      dotnet-sdk_7
      _7zz
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

      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = "32";
      XCURSOR_THEME = "Adwaita";
      NIXOS_OZONE_WL = "1";

      MOZ_USE_XINPUT2 = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
      MOZ_ACCELERATED = "1";

      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";

      XKB_DEFAULT_LAYOUT = "us";
      LIBSEAT_BACKEND = "logind";

      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";

      _JAVA_AWT_WM_NONREPARENTING = "1";
      GDK_BACKEND = "wayland";
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
      fullscreen = true;
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
