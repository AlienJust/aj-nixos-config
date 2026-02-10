{
  config,
  pkgs,
  ...
}: {
  #disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d

  sops = {
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      forgejo_db_pass = {
        neededForUsers = false;
        sopsFile = ../../../secrets/secrets.yaml;
      };
    };
  };

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

    nextcloud.enable = true;
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
      qmk.enable = false;
      ssh.enable = true;

      spoofdpi.enable = false;
      spoofdpi.doh = true;
      spoofdpi.windowSize = 1;

      tumbler.enable = true;

      fail2ban.enable = true;
      forgejo = {
        enable = true;
        domain = "git.alexdeb.ru";
        httpAddr = "0.0.0.0";
        sshPort = 4224;

        package = pkgs.forgejo;

        database = {
          createDatabase = true;
          name = "forgejo";
          type = "postgres";
          user = "forgejo";
          host = "127.0.0.1";
          passwordFile = config.sops.secrets.forgejo_db_pass.path;
        };
      };

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
