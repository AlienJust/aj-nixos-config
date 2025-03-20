{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.sway.keybindings;
  super = "Mod4";

  workspace1 = "workspace number 1";
  workspace2 = "workspace number 2";
  workspace3 = "workspace number 3";
  workspace4 = "workspace number 4";
  workspace5 = "workspace number 5";
  workspace6 = "workspace number 6";
  workspace7 = "workspace number 7";
  workspace8 = "workspace number 8";
  workspace9 = "workspace number 9";
  workspace10 = "workspace number 10";
  workspace11 = "workspace number 11";
  workspace12 = "workspace number 12";

  terminal = config.module.defaults.terminalCmd;
  qterm = "foot -T \"Floating Terminal\"";

  appLauncher = config.module.defaults.appLauncherCmd;
  audioControl = config.module.defaults.audioControlCmd;
  brightnessControl = config.module.defaults.brightnessControlCmd;
  clipHist = config.module.defaults.clipHistCmd;
  notificationsApp = config.module.defaults.notificationsAppCmd;

  screenshotArea = "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";
  screenshotScreen = "${pkgs.grim}/bin/grim -o $(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name') - | ${pkgs.wl-clipboard}/bin/wl-copy";

  powerMenu = pkgs.writeShellScriptBin "powerMenu.sh" ''
    #!/usr/bin/env bash

    op=$(echo -e " Poweroff\n Reboot\n Suspend\n Lock\n Logout" | ${pkgs.rofi-wayland}/bin/rofi -i -dmenu | ${pkgs.gawk}/bin/awk '{print tolower($2)}')

    case $op in
      poweroff)
        ;&
      reboot)
        ;&
      suspend)
        systemctl $op
        ;;
      lock)
        swaylock
        ;;
      logout)
        swaymsg exit
        ;;
    esac
  '';
in {
  options.module.sway.keybindings = {
    enable = mkEnableOption "Enable sway keybindings";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway.config = {
      inherit terminal;
      modifier = super;
      bindkeysToCode = true;

      assigns = {
        "workspace number 2" = [{app_id = "org.telegram.desktop";}];
        "4" = [{app_id = "obsidian";}];
        "8" = [{app_id = "vesktop";}];
      };

      keybindings = {
        # Terminal
        "${super}+Return" = "exec ${terminal}";

        # PowerMenu
        "${super}+p" = "exec ${powerMenu}/bin/powerMenu.sh";

        "${super}+Shift+Return" = "exec ${qterm}";

        # Kill active window
        "${super}+Shift+q" = "kill";
        "${super}+d" = "exec ${appLauncher}";
        "${super}+Shift+c" = "reload";
        "${super}+c" = ''mode "chat"'';
        "${super}+r" = ''mode "resize"'';

        # Notifications
        "${super}+n" = ''exec --no-startup-id "makoctl dismiss"'';
        "${super}+Shift+n" = ''exec --no-startup-id "makoctl dismiss --all"'';
        # Screenshots
        Print = ''exec IMG=~/Images/Screenshots/screen-$(date +%Y-%m-%d_%H-%m-%s).png && grim $IMG && wl-copy < $IMG'';
        "${super}+Print" = ''exec IMG=~/Images/Screenshots/screen-$(date +%Y-%m-%d_%H-%m-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG'';

        "${super}+Shift+minus" = "move scratchpad";
        "${super}+minus" = "scratchpad show";

        "Mod1+Control+l" = "exec --no-startup-id wlogout";

        "${super}+F11" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
        "${super}+F10" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
        "${super}+F9" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # Multimedia keys
        "xf86audioraisevolume" = "exec ${audioControl} set-sink-volume @DEFAULT_SINK@ +5%";
        "xf86audiolowervolume" = "exec ${audioControl} set-sink-volume @DEFAULT_SINK@ -5%";
        "xf86audiomute" = "exec ${audioControl} set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86MonBrightnessDown" = "exec ${brightnessControl} set 5%-";
        "XF86MonBrightnessUp" = "exec ${brightnessControl} set +5%";

        #        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        #        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        #        "XF86AudioPlay" = "exec playerctl play-pause";
        #        "XF86AudioNext" = "exec playerctl next";
        #        "XF86AudioPrev" = "exec playerctl previous";
        "${super}+Left" = "focus left";
        "${super}+Up" = "focus up";
        "${super}+Down" = "focus down";
        "${super}+Right" = "focus right";

        "${super}+Shift+Left" = "move left";
        "${super}+Shift+Up" = "move up";
        "${super}+Shift+Down" = "move down";
        "${super}+Shift+Right" = "move right";

        "${super}+1" = "workspace number 1";
        "${super}+2" = "workspace number 2";
        "${super}+3" = "workspace number 3";
        "${super}+4" = "workspace number 4";
        "${super}+5" = "workspace number 5";
        "${super}+6" = "workspace number 6";
        "${super}+7" = "workspace number 7";
        "${super}+8" = "workspace number 8";
        "${super}+9" = "workspace number 9";
        "${super}+0" = "workspace number 10";
        "${super}+F1" = "workspace number 11";
        "${super}+F2" = "workspace number 12";
        "${super}+F3" = "workspace number 13";
        "${super}+F4" = "workspace number 14";
        "${super}+F5" = "workspace number 15";
        "${super}+F6" = "workspace number 16";
        "${super}+F7" = "workspace number 17";
        "${super}+F8" = "workspace number 18";
        "${super}+F12" = "workspace number 22";

        "${super}+Shift+1" = "move container to workspace number 1";
        "${super}+Shift+2" = "move container to workspace number 2";
        "${super}+Shift+3" = "move container to workspace number 3";
        "${super}+Shift+4" = "move container to workspace number 4";
        "${super}+Shift+5" = "move container to workspace number 5";
        "${super}+Shift+6" = "move container to workspace number 6";
        "${super}+Shift+7" = "move container to workspace number 7";
        "${super}+Shift+8" = "move container to workspace number 8";
        "${super}+Shift+9" = "move container to workspace number 9";
        "${super}+Shift+0" = "move container to workspace number 10";
        "${super}+Shift+F1" = "move container to workspace number 11";
        "${super}+Shift+F2" = "move container to workspace number 12";
        "${super}+Shift+F3" = "move container to workspace number 13";
        "${super}+Shift+F4" = "move container to workspace number 14";
        "${super}+Shift+F5" = "move container to workspace number 15";
        "${super}+Shift+F6" = "move container to workspace number 16";
        "${super}+Shift+F7" = "move container to workspace number 17";
        "${super}+Shift+F8" = "move container to workspace number 18";
        "${super}+Shift+F12" = "move container to workspace number 22";

        "${super}+Tab" = ''exec "echo 1 > /tmp/sovpipe"'';
        "${super}+q" = ''exec "echo 0 > /tmp/sovpipe"'';

        "${super}+b" = "splith";
        "${super}+v" = "splitv";

        "${super}+s" = "layout stacking";
        "${super}+w" = "layout tabbed";
        "${super}+e" = "layout toggle split";

        "${super}+f" = "fullscreen";
        "${super}+Shift+f" = "fullscreen global";

        "${super}+Shift+space" = "floating toggle";
        "${super}+space" = "focus mode_toggle";
        "${super}+a" = "focus parent";

        # TODO: warpd bindings
        # TODO: volume control notifications
      };

      modes = {
        resize = {
          Left = "resize shrink width 10 px or 1 ppt";
          Down = "resize grow height 10 px or 1 ppt";
          Up = "resize shrink height 10 px or 1 ppt";
          Right = "resize grow width 10 px or 1 ppt";
          Return = ''mode "default"'';
          Escape = ''mode "default"'';

          "Shift+Left" = "resize shrink width 20 px or 5 ppt";
          "Shift+Down" = "resize grow height 20 px or 5 ppt";
          "Shift+Up" = "resize shrink height 20 px or 5 ppt";
          "Shift+Right" = "resize grow width 20 px or 5 ppt";
        };
      };
    };
  };
}
