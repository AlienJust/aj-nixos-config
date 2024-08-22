{
  inputs,
  config,
  lib,
  pkgs,
  homeModules,
  hostname,
  ...
}:
with lib; let
  cfg = config.module.sway;
  modifier = "Mod4";
  terminal = "foot";
  qterm = "foot -T \"Floating Terminal\"";
  menu = "wofi -i --show drun";
in {
  imports = [
    #"${homeModules}/sway/binds"
    #"${homeModules}/sway/monitors"
  ];

  options = {
    module.sway.enable = mkEnableOption "Enable Sway";
  };

  config = mkIf cfg.enable {
    module.hyprland = {
      binds.enable = mkDefault cfg.enable;
      monitors.enable = mkDefault cfg.enable;
    };

    home.packages = with pkgs; [
      /*
        imagemagick
      grimblast
      wl-clipboard
      wf-recorder
      hyprpicker
      waypaper
      cliphist
      imv
      gtk3
      dbus
      glib
      swww
      xdg-utils
      pavucontrol
      cinnamon.nemo
      eww
      networkmanagerapplet
      brightnessctl
      */

      grim
      slurp
      swaybg
      eww
      wl-clipboard
      hyprpicker
      playerctl
      waybar
      /*
        (
        waybar.override {
          wireplumberSupport = false;
        }
      )
      */
      #mako
      foot

      swayidle
      wofi
      swayest-workstyle
    ];

    wayland.windowManager.sway = {
      enable = true;
      systemd.enable = true;
      wrapperFeatures.gtk = true;
      swaynag.enable = true;
      #      export QT_QPA_PLATFORMTHEME="qt5ct"
      #      export QT_QPA_PLATFORMTHEME="kde"
      extraSessionCommands = with pkgs; ''
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

        export QT_AUTO_SCREEN_SCALE_FACTOR="1"

        export XDG_CURRENT_DESKTOP="sway"

        export NIXOS_OZONE_WL="1"

        export CLUTTER_BACKEND="wayland"
        export SDL_VIDEODRIVER="wayland"
        export _JAVA_AWT_WM_NONREPARENTING="1"
        export GDK_BACKEND="wayland"
      '';
      #      export XDG_SESSION_TYPE="x11"
      #      export XCURSOR_SIZE=32
      #      export XCURSOR_THEME="Adwaita"

      #      export MC_SKIN=$HOME/.config/mc/selenized.ini;
      #      export XDG_DATA_DIRS="${gnome.adwaita-icon-theme}/share:$XDG_DATA_DIRS";
      #    '';
      config = {
        modifier = modifier;
        terminal = terminal;
        menu = menu;
        workspaceAutoBackAndForth = true;

        # TODO: fonts.
        /*
          fonts = {
          names = ["pango:Hack" "FontAwesome"];
          size = 12.0;
        };
        */

        #output = {"*" = {bg = "~/wall.jpg fill";};};

        input = {
          "*" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:caps_toggle";
            xkb_numlock = "enable";
          };
        };

        focus.followMouse = "no";

        /*
        colors = {
          focused = {
            border = "#6272A4";
            background = "#44475A";
            text = "#F8F8F2";
            indicator = "#6272A4";
            childBorder = "#6272A4";
          };
          unfocused = {
            border = "#282A36";
            background = "#282A36";
            text = "#BFBFBF";
            indicator = "#282A36";
            childBorder = "#282A36";
          };
          focusedInactive = {
            border = "#44475A";
            background = "#44475A";
            text = "#F8F8F2";
            indicator = "#44475A";
            childBorder = "#44475A";
          };
          urgent = {
            border = "#44475A";
            background = "#FF5555";
            text = "#F8F8F2";
            indicator = "#FF5555";
            childBorder = "#FF5555";
          };
          #background = black;
        };
        */

        floating = {
          titlebar = false;
          border = 3;
          criteria = [
            {
              window_role = "pop-up";
            }
            {
              window_role = "bubble";
            }
            {
              window_role = "task_dialog";
            }
            {
              window_role = "Preferences";
            }
            {
              window_type = "dialog";
            }
            {
              window_type = "popup_menu";
            }
            {
              window_type = "menu";
            }

            {
              title = "(?:Open|Save) (?:File|Folder|As)";
            }

            {
              app_id = "imv";
            }
            {
              app_id = "galculator";
            }
            {
              app_id = "pavucontrol";
            }
            {
              app_id = "foot";
              title = "Floating Terminal";
            }

            # JBIDE
            {
              title = "win0";
            }
          ];
        };

        window = {
          titlebar = false;
          border = 3;
          commands = [
            {
              command = "resize set 800 600";
              criteria.title = "(?:Open|Save) (?:File|Folder|As)";
            }
            # TODO: remove?
            {
              command = "floating enable";
              criteria.app_id = "foot";
              criteria.title = "Floating Terminal";
            }
            # TODO: no focus for MPV
            {
              command = "floating enable, resize set 640 400, sticky enable";
              criteria.app_id = "mpv";
            }

            # TODO: no focus for Picture in picture mode
            {
              command = "floating enable, resize set 640 400, sticky enable";
              criteria.title = "^Картинка в картинке";
            }

            {
              command = "floating enable, resize set 640 400, sticky enable";
              criteria.title = "^Picture-in-Picture";
            }

            #WTF?
            {
              command = "move scratchpad";
              criteria.class = "KDE Connect";
            }
            {
              command = "scratchpad show";
              criteria.class = "KDE Connect";
            }
          ];
        };

        gaps = {
          inner = 0;
          outer = 0;
          smartBorders = "on";
        };

        # TODO: border

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

        bindkeysToCode = true;
        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+Return" = "exec ${qterm}";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Shift+c" = "reload";
          "${modifier}+c" = ''mode "chat"'';
          "${modifier}+r" = ''mode "resize"'';

          # Notifications
          "${modifier}+n" = ''exec --no-startup-id "makoctl dismiss"'';
          "${modifier}+Shift+n" = ''exec --no-startup-id "makoctl dismiss --all"'';
          # Screenshots
          Print = ''exec IMG=~/Изображения/screen-$(date +%Y-%m-%d_%H-%m-%s).png && grim $IMG && wl-copy < $IMG'';
          "${modifier}+Print" = ''exec IMG=~/Downloads/screen-$(date +%Y-%m-%d_%H-%m-%s).png && grim -g "$(slurp)" $IMG && wl-copy < $IMG'';

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "Mod1+Control+l" = "exec --no-startup-id wlogout";

          "${modifier}+F11" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
          "${modifier}+F10" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0";
          "${modifier}+F9" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          #        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          #        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
          #        "XF86AudioPlay" = "exec playerctl play-pause";
          #        "XF86AudioNext" = "exec playerctl next";
          #        "XF86AudioPrev" = "exec playerctl previous";
          "${modifier}+Left" = "focus left";
          "${modifier}+Up" = "focus up";
          "${modifier}+Down" = "focus down";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";
          "${modifier}+F1" = "workspace number 11";
          "${modifier}+F2" = "workspace number 12";
          "${modifier}+F3" = "workspace number 13";
          "${modifier}+F4" = "workspace number 14";
          "${modifier}+F5" = "workspace number 15";
          "${modifier}+F6" = "workspace number 16";
          "${modifier}+F7" = "workspace number 17";
          "${modifier}+F8" = "workspace number 18";
          "${modifier}+F12" = "workspace number 22";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          "${modifier}+Shift+F1" = "move container to workspace number 11";
          "${modifier}+Shift+F2" = "move container to workspace number 12";
          "${modifier}+Shift+F3" = "move container to workspace number 13";
          "${modifier}+Shift+F4" = "move container to workspace number 14";
          "${modifier}+Shift+F5" = "move container to workspace number 15";
          "${modifier}+Shift+F6" = "move container to workspace number 16";
          "${modifier}+Shift+F7" = "move container to workspace number 17";
          "${modifier}+Shift+F8" = "move container to workspace number 18";
          "${modifier}+Shift+F12" = "move container to workspace number 22";

          "${modifier}+Tab" = ''exec "echo 1 > /tmp/sovpipe"'';
          "${modifier}+q" = ''exec "echo 0 > /tmp/sovpipe"'';

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+f" = "fullscreen global";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          # TODO: warpd bindings
          # TODO: volume control notifications
        };

        # TODO: floating criteria
        # floating = {criteria = [{class = "SpeedCrunch";}];};

        #bars = [{command = "waybar";}];
        bars = [];
        startup = [
          {
            command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP";
            always = false;
          }

          # Proper xdg working
          # See:   https://www.reddit.com/r/NixOS/comments/1aeju6n/unable_to_set_default_browser/
          # Also:  https://github.com/NixOS/nixpkgs/issues/189851
          {
            command = "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service";
            always = false;
          }

          # Mako startup
          #{
          #command = "mako";
          #always = false;
          #}

          # Swokstyle
          {
            command = "sworkstyle &> /tmp/sworkstyle.log";
            always = true;
          }
          /*
            {
            command = "sworkstyle &> /tmp/sworkstyle.log";
            always = false;
          }
          */
        ];

        # If mixos
        /*
          output = lib.mkIf (hostName == "mixos") {
          "DP-1" = {
            scale = "1";
            mode = "2560x1440@164.999Hz";
            pos = "1920 800";
          };
          "HDMI-A-1" = {
            mode = "1920x1080@60.000Hz";
            scale = "1";
            pos = "0 0";
          };
        };
        */

        output = lib.mkMerge [
          (lib.mkIf (hostname == "mixos") {
            "DP-1" = {
              scale = "1";
              mode = "2560x1440@164.999Hz";
              pos = "1920 700";
            };
            "HDMI-A-1" = {
              mode = "1920x1080@60.000Hz";
              scale = "1";
              pos = "0 0";
            };
          })

          (lib.mkIf (hostname == "wixos") {
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
          })
        ];
      };

      extraConfig = ''
        #exec --no-startup-id systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP
        #exec --no-startup-id mako &
        #exec_always --no-startup-id sworkstyle &> /tmp/sworkstyle.log
        #exec sworkstyle &> /tmp/sworkstyle.log

        # TODO: move to config.
        no_focus [app_id="^mpv"]
        no_focus [title="^Картинка в картинке"]

        # TODO:
        # Cursor
        #
        #seat seat0 xcursor_theme Catppuccin-Mocha-Peach-Cursors 24

        # TODO:
        # SOV

        # Switching at workspace 1 on start.
        workspace 1
      '';
      #      exec --no-startup-id kdeconnect-indicator &
      #      exec --no-startup-id swayidle -w timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"'
      #    '';
    };
  };
}
