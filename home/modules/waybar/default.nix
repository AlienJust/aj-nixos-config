{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.module.waybar;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in {
  options = {
    module.waybar.enable = mkEnableOption "Enables waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # systemd.target = "sway-session.target";
      systemd.target = "graphical-session.target";

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

      /*
      https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect
      workspaces button:hover {
              box-shadow: inherit;
              text-shadow: inherit;
              }
      */

      /*
      window#waybar {
              transition-property: background-color;
              transition-duration: .5s;
              opacity: 0.9;
          }
      */
      # config.lib.stylix.colors.base00
      style = concatStrings [
        ''
          * {
              border: none;
              border-radius: 0;
              min-height: 0;
          }


          #workspaces button {
              padding: 0 5px;
              min-width: 16px
          }

          #workspaces button label {
              color: #${config.lib.stylix.colors.base0B};
          }


          #workspaces button:hover {
              box-shadow: inherit;
              text-shadow: inherit;

              opacity: 0.8;
              transition: ${betterTransition};
              background: linear-gradient(45deg, #${config.lib.stylix.colors.base08}, #${config.lib.stylix.colors.base0D});
          }
          #workspaces button:hover label{
              color: #${config.lib.stylix.colors.base00};
          }
        ''
      ];

      settings = [
        {
          #height = lib.mkForce 26;
          height = 30;
          layer = "top";
          position = "top";
          tray = {
            icon-size = 18;
            show-passive-items = true;
            spacing = 8;
          };

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
            # "custom/keyboard-layout"
            "sway/language"
            "custom/notification"
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

          # Pulseaudio
          /*
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
          */

          pulseaudio = {
            format = "{volume} {icon} / {format_source}";
            format-source = "󰍬";
            format-source-muted = "󰍭";
            format-muted = "󰖁 / {format_source}";
            format-icons = {default = ["󰕿" "󰖀" "󰕾"];};
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            on-click-right = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
            on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
            tooltip = false;
          };

          # Keyboard layout
          "sway/language" = {
            format = "{flag} {shortDescription} ";
          };
          /*
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
          */

          #      temperature = {
          #        critical-threshold = 80;
          #        format = "{temperatureC}°C {icon}";
          #        format-icons = [ "" "" "" ];
          #      };

          # Notifications
          "custom/notification" = {
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            return-type = "json";
            format = "{icon}  ";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            escape = true;

            format-icons = {
              notification = "󰂚";
              none = "󰂜";
              dnd-notification = "󰂛";
              dnd-none = "󰪑";
              inhibited-notification = "󰂛";
              inhibited-none = "󰪑";
              dnd-inhibited-notification = "󰂛";
              dnd-inhibited-none = "󰪑";
            };
          };
        }
      ];
    };
  };
}
