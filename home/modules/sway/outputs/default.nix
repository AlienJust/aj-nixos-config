{
  config,
  lib,
  hostname,
  ...
}:
with lib; let
  cfg = config.module.sway.outputs;

  outputs = {
    default = {};

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

    mixos = [
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
        workspace = "11";
        output = "DP-1";
      }
      {
        workspace = "13";
        output = "DP-1";
      }
      {
        workspace = "15";
        output = "DP-1";
      }
      {
        workspace = "17";
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
        workspace = "12";
        output = "HDMI-A-1";
      }
      {
        workspace = "14";
        output = "HDMI-A-1";
      }
      {
        workspace = "16";
        output = "HDMI-A-1";
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
