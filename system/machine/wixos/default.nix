{
  hyprlandEnable,
  config,
  ...
}: {
  #disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d

  services.dbus.implementation = "broker";

  module = {
    sound.enable = true;
    boot.enable = true;
    console.enable = true;
    fonts.enable = true;
    games.enable = true;
    locales.enable = true;
    network.enable = true;
    stylix.enable = true;
    timedate.enable = true;
    users.enable = true;
    variables.enable = true;
    virtualisation.enable = true;

    security = {
      enable = true;
      enableBootOptions = true;
      disableIPV6 = false;
    };

    minimal.enable = true;
    nixos-ng.enable = true;
    plymouth.enable = true;
    binfmt.enable = true;

    services = {
      rudpt.enable = true;

      bagetter.enable = true;
      scx = {
        enable = true;
        schedulerType = "scx_bpfland";
      };
      bolt.enable = true;
      devmon.enable = true;
      fstrim.enable = true;
      fwupd.enable = true;
      gvfs.enable = true;
      polkit.enable = true;
      polkit-gnome-agent.enable = true;
      # printing.enable = true;
      syncthing.enable = true;
      udev.enable = true;
      greetd-tui.enable = false;
      hyprland.enable = hyprlandEnable;
      qmk.enable = true;
      ssh.enable = true;

      spoofdpi = {
        enable = false;
        doh = true;
        windowSize = 1;
      };

      tumbler.enable = true;

      ollama = {
        #enable = true;
        enable = false;
        gpuSupport.enable = config.services.ollama.enable;
      };

      udisks2.enable = true;

      zapret.enable = false;
    };

    programs = {
      adb.enable = true;
      dconf.enable = true;
      fish.enable = false;
      gnupg.enable = true;
      hm.enable = true;
      kdeconnect.enable = false;
      mtr.enable = true;
      nh.enable = true;
      systemPackages.enable = true;
      thunar.enable = true;
      xdg-portal.enable = true;
      zsh.enable = true;
    };

    hpb.enable = false;
  };
}
