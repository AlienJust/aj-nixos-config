# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    #impermanence
    (inputs.impermanence + "/home-manager.nix")

    # Apps
    ./applications/vscode.nix
    ./applications/firefox
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
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ 
    zsh
    oh-my-zsh
    dconf
    git
    socat
    htop
    mc
    telegram-desktop
    steam
    mpv
    grim
    slurp
    btop
    swaybg
    obs-studio
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  # New: Now we can use the "home.persistence" module, here's an example:
  home.persistence."/nix/persist/home/aj01" = {
    directories = [ 
      ".ssh" 
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
#      ".config/dconf/user"
      ".config/gnome-initial-setup-done"
    ];
    allowOther = true; # Useful for sudo operations
  };

  programs.git = {
    enable = true;
    userName = "Alexey Debelov";
    userEmail = "alienjustmail@gmail.com";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

#  programs.dconf = {
#    enable = true;
#  };

  sessionVariables = {
      BROWSER = "firefox";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = "16";
      XCURSOR_THEME = "Adwaita";
      NIXOS_OZONE_WL = "1";
      MOZ_USE_XINPUT2 = "1";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
