{config, ...}: {
  #disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d

  services.dbus.implementation = "broker";

  module = {
    sound.enable = true;
    boot.enable = true;
    console.enable = true;
    fonts.enable = true;

    games.enable = false;

    locales.enable = true;
    network.enable = true;
    stylix.enable = true;
    timedate.enable = true;
    users.enable = true;
    variables.enable = true;

    virtualisation.enable = false;

    security = {
      enable = true;
      # enableBootOptions = true;
      disableIPV6 = false;
    };

    minimal.enable = true;
    nixos-ng.enable = true;
    plymouth.enable = true;
    binfmt.enable = true;

    bagetter.enable = true;
    bagetter.hostname = "nuget.alexdeb.ru";

    nextcloud.enable = false;
    nextcloud.hostname = "nxoo.alexdeb.ru";

    services = {
      rudpt.enable = true;

      zram.enable = true;

      bolt.enable = true;
      devmon.enable = false;
      fstrim.enable = true;
      fwupd.enable = true;
      gvfs.enable = true;
      polkit.enable = true;
      polkit-gnome-agent.enable = true;
      printing.enable = true;
      syncthing.enable = true;
      udev.enable = true;
      greetd-tui.enable = false;
      qmk.enable = true;
      ssh.enable = true;

      spoofdpi.enable = false;
      spoofdpi.doh = true;
      spoofdpi.windowSize = 1;

      tumbler.enable = true;

      /*
      ollama = {
        #enable = true;
        enable = false;
        gpuSupport.enable = config.services.ollama.enable;
      };
      */

      udisks2.enable = true;

      zapret.enable = true;
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
