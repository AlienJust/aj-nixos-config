{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    #    style = ''
    #      ${builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css"}
    #      window#waybar {
    #        background: transparent;
    #        border-bottom: none;
    #      }
    #      * {
    #        ${
    #        if config.hostId == "yoga"
    #        then ''
    #          font-size: 18px;
    #        ''
    #        else ''

    #        ''
    #      }
    #      }
    #    '';
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: Hack Nerd Font, Overpass Mono, Fantasque Sans Mono, FontAwesome5Free Solid;
          font-size: 11px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(40, 42, 54, 0.8);
          border-bottom: 3px solid rgba(100, 114, 125, 0.5);
          color: #F8F8F2;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      /*
      window#waybar.empty {
          background-color: transparent;
      }
      window#waybar.solo {
          background-color: #FFFFFF;
      }
      */

      window#waybar.alacritty {
          background-color: #3F3F3F;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
          border-bottom: 3px solid transparent;
          min-width: 16px
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
          box-shadow: inherit;
          border-bottom: 3px solid #ffffff;
      }

      #workspaces button.focused {
          background-color: #44475A;
          border-bottom: 3px solid #44475A;
      }

      #workspaces button.urgent {
          background-color: #FF5555;
      }

      #mode {
          background-color: #FF5555;
          border-bottom: 3px solid #FF5555;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #mpd,
      #custom-updates {
          padding: 0 5px;
          margin: 0 4px;
          color: #f8f8f2;
      }

      #clock {
          /*background-color: #64727D;*/
      }

      #battery {
          /*background-color: #ffffff;*/
          /*color: #000000;*/
      }

      #battery.charging {
          /*background-color: #26A65B;*/
          color: #50fa7b;
      }

      #battery.warning:not(.charging) {
          /*background-color: #;*/
          color: #b45bcf;
      }

      @keyframes blink {
          to {
              background-color: #ff5555;
              color: #282a36;
          }
      }

      #battery.critical:not(.charging) {
          /*background-color: #;*/
          color: #ff5555;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          /*background-color: #2ecc71;*/
          /*color: #000000;*/
      }

      #memory {
          /*background-color: #9b59b6;*/
      }

      #network {
          /*background-color: #2980b9;*/
      }

      #network.disconnected {
          /*background-color: #f53c3c;*/
      }

      #pulseaudio {
          /*background-color: #f1c40f;*/
          /*color: #000000;*/
      }

      #pulseaudio.muted {
          /*background-color: #90b1b1;*/
          /*color: #2a5c45;*/
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #idle_inhibitor {
          /*background-color: #2d3436;*/
      }

      #idle_inhibitor.activated {
          background-color: #b45bcf;
          color: #f8f8f2;
      }

      #mpd {
          /*background-color: #282a36;*/
          /*color: #2a5c45;*/
      }

      #mpd.disconnected {
          /*background-color: #283a26;*/
          /*color: #f8f8f2*/
      }

      #mpd.stopped {
          /*background-color: #283a26;*/
          /*color: #f8f8f2*/
      }

      #mpd.paused {
          /*background-color: #283a26;*/
      }
      #custom-updates {
          color: #ff5555;
      }'';
    settings = [
      {
        height = 26;
        layer = "top";
        position = "top";
        tray = {spacing = 10;};

        modules-left = ["sway/workspaces" "sway/mode"];
        "sway/mode" = {format = ''<span style="italic">{}</span>'';};

        modules-center = ["sway/window"];
        "sway/window" = {
          "max-length" = 80;
          "tooltip" = false;
        };

        modules-right = [
          "mpd"
          "tray"
          "pulseaudio"
          "memory"
          "clock"
          "custom/keyboard-layout"
          # "sway/language"
        ]; # ++ (if config.hostId == "yoga" then [ "battery" ] else [ ])
        #      ++ [
        #        "clock"
        #        "tray"
        #      ];
        #      battery = {
        #        format = "{capacity}% {icon}";
        #        format-alt = "{time} {icon}";
        #        format-charging = "{capacity}% ";
        #        format-icons = [ "" "" "" "" "" ];
        #        format-plugged = "{capacity}% ";
        #        states = {
        #          critical = 15;
        #          warning = 30;
        #        };
        #      };

        mpd = {
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          unknown-tag = "N/A";
          interval = 2;
          consume-icons = {
            on = " ";
          };
          random-icons = {
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip = false;
        };

        clock = {
          format = "{:%a %d %b <b>%H:%M</b>}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          interval = 5;
        };
        "custom/keyboard-layout" = {
          exec = pkgs.writeShellScript "layout" ''
            #!/bin/sh

            DEFAULT_LAYOUT="English (US)"

            # Kill old instances since waybar don't kill them when exited
            [ "$(pgrep -a 'swaymsg' | grep -c '["input"]')" -gt 0 ] &&
              pgrep -a 'swaymsg' | grep '["input"]' | cut -d ' ' -f1 | xargs -r kill

            # Sleep for a short while in order to prevent startup issues in waybar
            sleep 0.5

            keyboard_flag() {
              while read -r layout; do
                if [ "$layout" = "English (US)" ]; then
                  layout_waybar="🇺🇸 EN "
                elif [ "$layout" = "Russian" ]; then
                  layout_waybar="🇷🇺 RU "
                else
                  layout_waybar="$layout"
                fi

                printf '%s\n' "$layout_waybar"
              done
            }

            echo "$DEFAULT_LAYOUT" | keyboard_flag
            swaymsg -mrt subscribe '["input"]' | jq -r --unbuffered "select(.change == \"xkb_layout\") | .input | select(.type == \"keyboard\") | .xkb_active_layout_name" | keyboard_flag
          '';
          # Interval set only as a fallback, as the value is updated by signal
          # "interval": 5,
          format = "{}"; # Icon: keyboard
          # Signal sent by Sway key binding (~/.config/sway/key-bindings)
          signal = 1; # SIGHUP
          tooltip = false;
        };
        memory = {
          format = "{}% ";
          tooltip = true;
        };
        #        network = {
        #          interval = 1;
        #          format-alt = "{ifname}: {ipaddr}/{cidr}";
        #          format-disconnected = "Disconnected ⚠";
        #          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
        #          format-linked = "{ifname} (No IP) ";
        #          format-wifi = "{essid} ({signalStrength}%) ";
        #        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = ["" "" ""];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = "";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
          tooltip = true;
        };

        #      temperature = {
        #        critical-threshold = 80;
        #        format = "{temperatureC}°C {icon}";
        #        format-icons = [ "" "" "" ];
        #      };
      }
    ];
  };
}
