_: {
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

  networking.wireless.enable = true;

  systemd.network = {
    enable = true;

    networks = {
      # Add all adapters to br0 bridge
      "10-lan-wifi" = {
        matchConfig.Name = "wlan0";
        # acquire a DHCP lease on link up
        networkConfig = {
          Address = "192.168.50.112/24";
          Gateway = "192.168.50.1";
          # DNS = ["8.8.8.8"];
          # DHCP = "yes";
          # IPv6AcceptRA = true;
        };
        # this port is not always connected and not required to be online
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
