_: {
  networking = {
    hostName = "wixos";
    useDHCP = false;
    firewall.enable = false;
    extraHosts = ''
      192.168.6.32 elma.horizont.local
    '';
  };

  networking.nameservers = ["192.168.150.1#one.one.one.one" "8.8.8.8.#google"];
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    extraConfig = ''
      DNSOverTLS=no
    '';
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
          Address = ["192.168.150.33/24" "192.168.1.222/24"];
          IPv4Forwarding = true;
          Gateway = "192.168.150.1";
          LinkLocalAddressing = "no";
        };
        #linkConfig.RequiredForOnline = "no";
      };
    };
  };

  networking.wg-quick.interfaces = {
    wg1 = {
      address = ["10.6.0.2/32"];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/home/aj01/wireguard-keys/home_privatekey";

      peers = [
        {
          publicKey = "vJJN13FxDcPMMrtnfPa+SbFIUcAENVBC3OlY4Ps88xI=";
          allowedIPs = ["192.168.50.0/24" "192.168.52.0/24"];
          endpoint = "aj01.asuscomm.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
