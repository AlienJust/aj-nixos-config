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
    };
  };

  networking = {
    #hostName = "mixos";
    useDHCP = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [22];
    nftables.enable = false;

    extraHosts = ''
      192.168.6.32 elma.horizont.local
    '';
  };
  networking.nameservers = ["1.1.1.1#one.one.one.one" "8.8.8.8.#google"];
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    dnsovertls = "true";
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
          Address = [
            /*
            "192.168.50.33/24"
            */
            "192.168.50.249/24"
          ];
          IPv4Forwarding = true;
          Gateway = "192.168.50.1";
          LinkLocalAddressing = "no";
        };
        #linkConfig.RequiredForOnline = "no";
      };
    };
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "10.66.66.2/32"
        /*
        "fd42:42:42::2/128"
        */
      ];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      # privateKeyFile = "/home/aj01/wireguard-keys/privatekey";
      privateKeyFile = config.sops.secrets.work_privatekey.path;

      peers = [
        {
          publicKey = "AHK8uBAHN29XfPYJmzh/hjhOkEGuzf/HDZRayR7RlBw=";
          presharedKeyFile = config.sops.secrets.work_presharedk.path;
          allowedIPs = ["192.168.167.0/24" "192.168.11.0/24" "192.168.6.0/24"];
          endpoint = "79.172.45.20:40414";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
