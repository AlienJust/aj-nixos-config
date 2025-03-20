{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.timedate;
in {
  options = {
    module.timedate.enable = mkEnableOption "Enables timedate";
  };

  config = mkIf cfg.enable {
    # Time settings
    #time.timeZone = "Europe/Moscow";
    time.timeZone = "Asia/Yekaterinburg";
    services.ntpd-rs.enable = true;
  };
}
