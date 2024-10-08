{
  hyprlandEnable,
  config,
  ...
}: {
  services.dbus.implementation = "broker";

  module = {
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

    chaotic = {
      enable = false;
      schedulerType = "scx_bpfland";
    };

    security = {
      enable = true;
      enableBootOptions = true;
      disableIPV6 = true;
    };

    services = {
      bolt.enable = true;
      devmon.enable = true;
      fstrim.enable = true;
      fwupd.enable = true;
      gvfs.enable = true;
      polkit.enable = true;
      polkit-gnome-agent.enable = true;
      printing.enable = true;
      syncthing.enable = true;
      udev.enable = true;
      greetd-tui.enable = false;
      hyprland.enable = hyprlandEnable;
      qmk.enable = true;
      ssh.enable = true;

      spoofdpi.enable = true;
      spoofdpi.doh = true;
      spoofdpi.windowSize = 1;

      tumbler.enable = true;

      ollama = {
        #enable = true;
        enable = false;
        gpuSupport.enable = config.services.ollama.enable;
      };

      udisks2.enable = true;
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
  };
}
