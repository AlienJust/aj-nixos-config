{config, ...}: {
  #disabledModules = ["services/networking/zapret.nix"]; # необходимо если версия nixpkgs новее 5a5c04d
  sops = {
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      nix-serve-privatekey = {
        owner = "nix-serve";
        neededForUsers = false;
        sopsFile = ../../../secrets/secrets.yaml;
      };
    };
  };

  services.dbus.implementation = "broker";

  services.nix-serve = {
    enable = true;
    port = 5000;
    secretKeyFile = config.sops.secrets.nix-serve-privatekey.path;
  };

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
      scx = {
        enable = true;
        schedulerType = "scx_bpfland";
      };
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

      ollama = {
        #enable = true;
        enable = false;
        gpuSupport.enable = config.services.ollama.enable;
      };

      udisks2.enable = true;

      zapret.enable = true;

      #zapret.enable = false;
      /*
      zapret-custom = {
        enable = true;
        mode = "nfqws";
        disableIpv6 = true;

        settings = ''
          SET_MAXELEM=522288
          IPSET_OPT="hashsize 262144 maxelem $SET_MAXELEM"

          IP2NET_OPT4="--prefix-length=22-30 --v4-threshold=3/4"
          IP2NET_OPT6="--prefix-length=56-64 --v6-threshold=5"
          AUTOHOSTLIST_RETRANS_THRESHOLD=3
          AUTOHOSTLIST_FAIL_THRESHOLD=3
          AUTOHOSTLIST_FAIL_TIME=60
          AUTOHOSTLIST_DEBUGLOG=0

          MDIG_THREADS=30

          GZIP_LISTS=1
          QUIC_PORTS=50000-65535

          MODE_HTTP=1
          MODE_HTTP_KEEPALIVE=0
          MODE_HTTPS=1
          MODE_QUIC=1
          MODE_FILTER=none

          DESYNC_MARK=0x40000000
          DESYNC_MARK_POSTNAT=0x20000000
          NFQWS_OPT_DESYNC="--dpi-desync=fake --dpi-desync-ttl=0 --dpi-desync-ttl6=0 --dpi-desync-fooling=badsum"
          NFQWS_OPT_DESYNC_HTTP="--dpi-desync=split --dpi-desync-ttl=5"
          NFQWS_OPT_DESYNC_HTTPS="--dpi-desync=fake --dpi-desync-ttl=5"
          NFQWS_OPT_DESYNC_QUIC="--dpi-desync=fake,tamper --dpi-desync-repeats=6 --dpi-desync-any-protocol"

          TPWS_OPT="--hostspell=HOST --split-http-req=method --split-pos=3 --hostcase --oob"

          FLOWOFFLOAD=donttouch

          INIT_APPLY_FW=1
        '';
      };
      */
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
