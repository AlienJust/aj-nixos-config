{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.murmur;
in {
  options = {
    module.services.murmur.enable = mkEnableOption "Enable murmur (mumble) server";
  };

  config = mkIf cfg.enable {
    services.murmur = {
      enable = true;
      openFirewall = true; # Opens port 9987 (UDP)
    };
  };
}
