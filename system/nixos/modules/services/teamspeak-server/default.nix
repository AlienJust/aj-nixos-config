{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.teamspeak-server;
in {
  options = {
    module.services.teamspeak-server.enable = mkEnableOption "Enable teamspeak-server";
  };

  config = mkIf cfg.enable {
    services.teamspeak3 = {
      enable = true;
      openFirewall = true; # Opens port 9987 (UDP)
    };
  };
}
