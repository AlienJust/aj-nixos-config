{
  isWorkstation,
  isLinux,
  hyprlandEnable ? false,
  swayEnable ? false,
  wmEnable ? false,
  ...
}: {
  nixpkgs.overlays = [
    # (import "${self}/home/overlays/rofi-calc")
    # (import "${self}/home/overlays/rofi-emoji")
  ];
  imports = [
    # for vscode settings r/w
    ./mutability.nix
  ];

  /*
  stylix.targets = {
    #vscode.enable = false;
    helix.enable = false;
  };
  */

  #programs.yandex-music.enable = isLinux && isWorkstation;
  #programs.yandex-music.tray.enable = isLinux && isWorkstation && true; # to enable tray support

  module = {
    alacritty.enable = isWorkstation;
    vscode.enable = isWorkstation;
    doom-emacs.enable = isWorkstation;
    zathura.enable = isWorkstation;

    chrome.enable = isLinux && isWorkstation;
    firefox.enable = isLinux && isWorkstation;
    foot.enable = isLinux && isWorkstation;
    ssh.enable = isLinux && isWorkstation;

    stylix.enable = isLinux && isWorkstation;
    kde-theme.enable = isLinux && isWorkstation;
    gtk.enable = isLinux && isWorkstation;

    #hyprland.enable = isLinux && isWorkstation;
    hyprland.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprlock.enable = hyprlandEnable && isLinux && isWorkstation;
    hypridle.enable = hyprlandEnable && isLinux && isWorkstation;
    hyprpaper.enable = hyprlandEnable && isLinux && isWorkstation;
    rofi.enable = hyprlandEnable && isLinux && isWorkstation;

    swaync.enable = (swayEnable || hyprlandEnable) && isLinux && isWorkstation;
    waybar.enable = (swayEnable || hyprlandEnable) && isLinux && isWorkstation;
    fuzzel.enable = (swayEnable || hyprlandEnable) && isLinux && isWorkstation;

    sway.enable = swayEnable && isLinux && isWorkstation;
    swaylock.enable = swayEnable && isLinux && isWorkstation;
    wlogout.enable = swayEnable && isLinux && isWorkstation;
    #mako.enable = false; #config.module.sway.enable;

    mpd.enable = isLinux && isWorkstation;
    mpv.enable = isLinux && isWorkstation;

    btop.enable = true;
    eza.enable = false;
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
    fish.enable = false;
    zoxide.enable = true;
    yazi.enable = true;

    user = {
      impermanence.enable = isLinux && isWorkstation;
      xdg.enable = isLinux && isWorkstation;

      packages.enable = true;
    };
  };
}
