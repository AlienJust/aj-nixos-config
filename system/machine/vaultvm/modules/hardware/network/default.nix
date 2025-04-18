{
  config,
  username,
  ...
}: {
  users.users.${username}.openssh.authorizedKeys.keys = config.module.defaults.ssh.pubKeys;

  networking = {
    hostName = "vaultvm";

    firewall = {
      allowedTCPPorts = [
        8001
        34861
      ];
    };
  };

  systemd.network = {
    enable = true;

    networks."10-eth" = {
      matchConfig.MACAddress = config.module.defaults.network.mac;

      address = [
        "${config.module.defaults.network.ip}/32"
      ];

      routes = [
        {
          Destination = "10.0.0.0/32";
          GatewayOnLink = true;
        }
        {
          Destination = "0.0.0.0/0";
          Gateway = "10.0.0.0";
          GatewayOnLink = true;
        }
      ];

      networkConfig = {
        DNS = [
          "10.0.0.2"
        ];
      };
    };
  };
}
