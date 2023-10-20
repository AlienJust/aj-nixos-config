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
    (inputs.impermanence + "/home-manager.nix")

    # Apps
    ./applications/hyprland.nix
    ./applications/vscode.nix
    ./applications/anyrun.nix
    ./applications/wezterm.nix
    ./applications/firefox
    ./applications/eww
    ./applications/spicetify.nix
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

  # TODO: Set your username
  home = {
    username = "aj01";
    homeDirectory = "/home/aj01";

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    packages = with pkgs; [
      dconf
      git
      socat

      htop
      btop
      mc

      telegram-desktop
      steam

      mpv
      obs-studio
      imv

      grim
      slurp
      swaybg
      eww-wayland
      wl-clipboard
      hyprpicker
      wlogout
      playerctl

      eza
      nil

      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "slab";})
      iosevka-bin
    ];

    # New: Now we can use the "home.persistence" module, here's an example:
    persistence."/nix/persist/home/aj01" = {
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
      XCURSOR_SIZE = "16";
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
  };

  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
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
  home.stateVersion = "23.05";
}
