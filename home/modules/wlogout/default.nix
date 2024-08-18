{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.module.wlogout;
in {
  options = {
    module.wlogout.enable = mkEnableOption "Enables wlogout";
  };

  config = mkIf cfg.enable {
    programs.wlogout = {
    enable = true;

    # Configuration
    layout = [
      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        #action = "hyprctl dispatch exit 0";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      /*
        {
        label = "suspend";
        action = "systemctl suspend && swaylock";
        text = "Suspend";
        keybind = "u";
      }
      */
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      /*
        {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      */
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };
  };
}


