_: {
  networking = {
    hostName = "hpb-nix";
    useDHCP = false;
    firewall.enable = false;
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
    networks = {
      "10-lan" = {
        matchConfig.Name = "lan";
        networkConfig.DHCP = "ipv4";
      };
    };
  };
}
