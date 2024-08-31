{
  self,
  config,
  hostModules,
  hostname,
  ...
}: let
  machineModules = "${self}/system/machine/${hostname}/modules";
in {
  imports = [
    "${hostModules}"
    "${machineModules}"
  ];

  module = {
    console.enable = true;
    fonts.enable = true;
    games.enable = true;
    locales.enable = true;
    network.enable = true;
    security.enable = true;
    stylix.enable = true;
    timedate.enable = true;
    users.enable = true;
    variables.enable = true;
    virtualisation.enable = true;

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
      hyprland.enable = true;
      qmk.enable = true;
      ssh.enable = true;

      spoofdpi.enable = true;
      spoofdpi.doh = true;
      spoofdpi.windowSize = 0;

      tumbler.enable = true;

      ollama = {
        enable = true;
        gpuSupport.enable = config.services.ollama.enable;
      };

      udisks2.enable = true;
    };

    programs = {
      dconf.enable = true;
      gnupg.enable = true;
      hm.enable = true;
      nh.enable = true;
      kdeconnect.enable = false;
      mtr.enable = true;
      xdg-portal.enable = true;
      zsh.enable = true;
      fish.enable = false;
      thunar.enable = true;
      systemPackages.enable = true;
    };
  };
}
