{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.module.waybar;
in {
  options = {
    module.waybar.enable = mkEnableOption "Enables waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "sway-session.target";
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

      # config.lib.stylix.colors.base00
      style = ''
        * {
            border: none;
            border-radius: 0;
            min-height: 0;
        }

        window#waybar {
            transition-property: background-color;
            transition-duration: .5s;
            opacity: 0.9;
        }

        #workspaces button {
            padding: 0 5px;
            min-width: 16px
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            box-shadow: inherit;
        }
      '';

      settings = [
        {
          #height = lib.mkForce 26;
          height = 30;
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
            # "custom/keyboard-layout"
            "sway/language"
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
          "sway/language" = {
            format = "{flag} {shortDescription} ";
          };
          #      temperature = {
          #        critical-threshold = 80;
          #        format = "{temperatureC}°C {icon}";
          #        format-icons = [ "" "" "" ];
          #      };
        }
      ];
    };
  };
}
