{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.polkit-gnome-agent;
in {
  options = {
    module.services.polkit-gnome-agent.enable = mkEnableOption "Enable polkit-gnome-agent";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      polkit_gnome
    ];
    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };
}
