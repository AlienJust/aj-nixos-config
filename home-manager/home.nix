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
     git
     socat
     htop
     mc
     telegram-desktop
     steam
     firefox
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  # New: Now we can use the "home.persistence" module, here's an example:
  home.persistence."/nix/persist/home/aj01" = {
    directories = [ 
      ".ssh" 
      "Downloads" 
      #".config" 
      #"aj-nixos-config"
      {
         directory = ".local/share/Steam";
         method = "symlink";
      }
    ];
    files = [ 
      ".bash_history" 
      ".zsh_history"
      ".zshrc"
      ".config/dconf/user"
      ".config/gnome-initial-setup-done"
    ];
    allowOther = true; # Useful for sudo operations
  };

  programs.git = {
    enable = true;
    userName = "Alexey Debelov";
    userEmail = "alienjustmail@gmail.com";
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
