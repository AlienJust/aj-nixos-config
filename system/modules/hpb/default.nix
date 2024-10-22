{
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.hpb;
in {
  options = {
    module.hpb.enable = mkEnableOption "Enables HPB";
  };

  config = mkIf cfg.enable {
    #services.netbird.enable = true;
    #environment.systemPackages = [pkgs.netbird-ui];

    #ystemd.services.NetworkManager-wait-online.enable = false;
    networking = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "br0";
      # Lazy IPv6 connectivity for the container
    };

    containers.hpb = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.11";
      hostAddress6 = "fc00::1";
      localAddress6 = "fc00::2";
      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
        };

        system.stateVersion = "24.11";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [80];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
      };
    };
  };
}
