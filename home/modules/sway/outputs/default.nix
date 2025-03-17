{
  config,
  lib,
  hostname,
  ...
}:
with lib; let
  cfg = config.module.sway.outputs;

  mixosMonitorLeftName = "HDMI-A-1";
  mixosMonitorRightName = "DP-1";

  outputs = {
    default = {};

    kixos = {
      HDMI-A-1 = {
        mode = "1920x1080@60.000Hz";
        scale = "1.4";
        pos = "0 0";
      };
    };

    mixos = {
      DP-1 = {
        scale = "1";
        mode = "2560x1440@164.999Hz";
        pos = "1920 700";
      };
      HDMI-A-1 = {
        mode = "1920x1080@60.000Hz";
        scale = "1";
        pos = "0 0";
      };
    };

    wixos = {
      "DP-1" = {
        scale = "1";
        mode = "1920x1080@60.000Hz";
        pos = "0 0";
      };
      "HDMI-A-1" = {
        mode = "1920x1080@60.000Hz";
        scale = "1";
        pos = "1920 0";
      };
      "DVI-D-1" = {
        mode = "1920x1080@60.000Hz";
        scale = "1";
        pos = "3840 0";
      };
    };
  };

  workspaces = {
    default = [];

    kixos = [];

    mixos = [
      # First monitor
      {
        workspace = "1";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "3";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "5";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "7";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "9";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "11";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "13";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "15";
        output = mixosMonitorLeftName;
      }
      {
        workspace = "17";
        output = mixosMonitorLeftName;
      }
      # Second monitor.
      {
        workspace = "2";
        output = mixosMonitorRightName;
      }
      {
        workspace = "4";
        output = mixosMonitorRightName;
      }
      {
        workspace = "6";
        output = mixosMonitorRightName;
      }
      {
        workspace = "8";
        output = mixosMonitorRightName;
      }
      {
        workspace = "10";
        output = mixosMonitorRightName;
      }
      {
        workspace = "12";
        output = mixosMonitorRightName;
      }
      {
        workspace = "14";
        output = mixosMonitorRightName;
      }
      {
        workspace = "16";
        output = mixosMonitorRightName;
      }
      {
        workspace = "18";
        output = mixosMonitorRightName;
      }
      {
        workspace = "22";
        output = mixosMonitorRightName;
      }
    ];

    wixos = [
      {
        workspace = "1";
        output = "DP-1";
      }
      {
        workspace = "3";
        output = "DP-1";
      }
      {
        workspace = "5";
        output = "DP-1";
      }
      {
        workspace = "7";
        output = "DP-1";
      }
      {
        workspace = "9";
        output = "DP-1";
      }

      {
        workspace = "2";
        output = "HDMI-A-1";
      }
      {
        workspace = "4";
        output = "HDMI-A-1";
      }
      {
        workspace = "6";
        output = "HDMI-A-1";
      }
      {
        workspace = "8";
        output = "HDMI-A-1";
      }
      {
        workspace = "10";
        output = "HDMI-A-1";
      }

      {
        workspace = "11";
        output = "DVI-D-1";
      }
      {
        workspace = "12";
        output = "DVI-D-1";
      }
      {
        workspace = "13";
        output = "DVI-D-1";
      }
      {
        workspace = "14";
        output = "DVI-D-1";
      }
      {
        workspace = "15";
        output = "DVI-D-1";
      }
      {
        workspace = "16";
        output = "DVI-D-1";
      }
      {
        workspace = "17";
        output = "DVI-D-1";
      }
      {
        workspace = "18";
        output = "DVI-D-1";
      }
      {
        workspace = "22";
        output = "DVI-D-1";
      }
    ];
  };
in {
  options.module.sway.outputs = {
    enable = mkEnableOption "Enable sway outputs";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway.config = {
      output = outputs.${hostname};

      workspaceOutputAssign = workspaces.${hostname};
    };
  };
}
