{config, ...}: {
  sops = {
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      home_privatekey = {
        neededForUsers = false;
        sopsFile = ../../../../../../secrets/secrets.yaml;
      };
      aj_wixos_work_privatekey = {
        neededForUsers = false;
        sopsFile = ../../../../../../secrets/secrets.yaml;
      };
      work_presharedk = {
        neededForUsers = false;
        sopsFile = ../../../../../../secrets/secrets.yaml;
      };
    };
  };

  networking = {
    hostName = "wixos";
    useDHCP = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [22 2222 30000];
    firewall.allowedUDPPorts = [30000];

    extraHosts = ''
      192.168.6.32 elma.horizont.local
      192.168.10.20 hpb.dev.horizont.local
    '';

    wireless.iwd = {
      enable = true;

      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  #networking.nameservers = ["1.1.1.1#one.one.one.one" "8.8.8.8#dns.google"];
  networking.nameservers = ["77.88.8.8" "193.58.251.251"];

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        DNS = "77.88.8.8#common.dns.yandex.ru 193.58.251.251#dns.skydns.ru";
        FallbackDNS = "77.88.8.1#common.dns.yandex.ru";

        # Перенесенные и переименованные опции (регистр важен!)
        DNSSEC = "true";
        DNSOverTLS = "opportunistic";
        Domains = ["~."];
      };
    };
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };
    networks = {
      # Add all adapters to br0 bridge
      "br0_en-all" = {
        matchConfig.Name = "en*";
        networkConfig = {
          Bridge = "br0";
          LinkLocalAddressing = "no";
        };
        linkConfig.RequiredForOnline = "no";
      };

      "br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          DHCP = "ipv4";
          # Address = [
          # "192.168.11.53/24"
          # ];
          /*
            Address = [
            "192.168.1.222/24"
            "192.168.150.33/24"
          ];
          Gateway = "192.168.150.1";
          */
          IPv4Forwarding = true;
          LinkLocalAddressing = "no";
        };
        #linkConfig.RequiredForOnline = "no";
      };

      "wlan0" = {
        matchConfig.Name = "wlan0";
        networkConfig.DHCP = "ipv4";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.wg-quick.interfaces = {
    wg1 = {
      address = ["10.6.0.2/32"];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      #privateKeyFile = "/home/aj01/wireguard-keys/home_privatekey";
      privateKeyFile = config.sops.secrets.home_privatekey.path;

      peers = [
        {
          publicKey = "vJJN13FxDcPMMrtnfPa+SbFIUcAENVBC3OlY4Ps88xI=";
          allowedIPs = ["192.168.50.0/24" "192.168.52.0/24"];
          endpoint = "alexdeb.ru:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    wg0 = {
      address = [
        "10.66.66.18/32"

        /*
        "fd42:42:42::2/128"
        */
      ];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      # privateKeyFile = "/home/aj01/wireguard-keys/privatekey";
      privateKeyFile = config.sops.secrets.aj_wixos_work_privatekey.path;

      peers = [
        {
          publicKey = "AHK8uBAHN29XfPYJmzh/hjhOkEGuzf/HDZRayR7RlBw=";
          presharedKeyFile = config.sops.secrets.work_presharedk.path;
          allowedIPs = ["192.168.167.0/24" "192.168.6.0/24"];
          endpoint = "79.172.45.20:40414";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
