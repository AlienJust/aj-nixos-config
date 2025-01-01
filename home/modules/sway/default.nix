{
  self,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.sway;
  # menu = "wofi -i --show drun";
  # menu = "fuzzel";
  # menu = "${pkgs.fuzzel}/bin/fuzzel -T ${terminal}";
in {
  imports = [
    "${self}/home/modules/sway/keybinds"
    "${self}/home/modules/sway/outputs"
  ];

  options = {
    module.sway.enable = mkEnableOption "Enable Sway";
  };

  config = mkIf cfg.enable {
    module.sway = {
      keybindings.enable = cfg.enable;
      outputs.enable = cfg.enable;
    };

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      GTK_CSD = 0;
    };

    gtk = {
      gtk3.extraConfig = {
        gtk-decoration-layout = ":";
      };
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

    home.file = {
      ".config/sworkstyle/config.toml".text = ''
        fallback = ''
        separator = ' '

        [matching]
        'discord' = ''
        'Hexchat' = ''
        'Element' = ''
        'telegramdesktop' = ''
        'org.telegram.desktop' = { type = 'exact', value = '' }

        'Steam' = ''
        "/.*Steam/" = ""

        'vlc' = ''
        'org.qbittorrent.qBittorrent' = ''
        'Thunderbird' = ''
        'thunderbird' = ''
        'Insomnia' = ''
        'gnome-calendar' = ''
        'font-manager' = '󰛖'
        'Google-chrome' = ''
        'Chromium' = ''
        'Brave-browser' = ''
        'qutebrowser' = ''
        'org.qutebrowser.qutebrowser' = ''
        'Slack' = ''

        'Code' = '󰨞 '
        'code-oss' = '󰨞'
        "/.*Visual Studio Code/" = "󰨞"

        'jetbrains-pycharm' = ' '
        'jetbrains-goland' = ' '
        'jetbrains-webstorm' = ' '
        'jetbrains-clion' = ' '
        'jetbrains-idea' = ' '
        'Spotify' = ''
        '/(?i)Github.*Firefox/' = ' '
        'firefox' = ' '
        'org.mozilla.firefox' = ' '
        'Firefox' = ' '
        'Nightly' = ' '
        'firefoxdeveloperedition' = ''
        '/nvim ?\w*/' = ''
        '/npm/' = '󰎙'
        '/node/' = '󰎙'
        '/yarn/' = '󰎙'
        'org.gnome.Nautilus' = ""
        'ranger' = ""
        'kitty' = ''
        'foot' = ''

        'footclient' = ''
        'org.remmina.Remmina' = '󰢹'
        '/GNU Image Manipulation Program/' = ''
        'FreeTube' = ''
        'jetbrains-idea-ce' = ''
        "libreoffice-calc" = ""
        "libreoffice-writer" = ""
        'Microsoft-edge' = '󰇩'

        'krita' = { type = 'exact', value = '' }


        "mpv" = ""
        "aerc" = ""
        "org.pwmt.zathura" = ""

        "pavucontrol" = "󰕾"
        "/.*Громкость/" = "󰕾"

        "/.*Mousepad/" = "󰷈"

        "/.*WinBox/" = "󰒄"

        "peek" = ""
        "qalculate-gtk" = ""
        "signal" = ""
        "swappy" = ""
        "vimiv" = ""

        "dmenu" = ""
        "dmenu-clipboard" = ""
        "dmenu-browser" = ""
        "dmenu-emoji" = ""
        "dmenu-pass generator" = ""

        '1Password' = ''
        'WebCord' = '󰙯'

        'Postman' = ''
        'Bitwarden' = ''

        "transmission-remote-gtk" = "󱑣"

        'VirtualBox Manager' = '󰹑'
        'VirtualBox Machine' = '󱎴'
        'virt-manager' = { type = 'exact', value = '󱄄' }

        "org.freecadweb.FreeCAD"= "󱑣"

        'thunar' = ''
        'nemo' = { type = 'exact', value = '' }
        'obsidian' = '󰠮'
        'KMines' = '󰷚'
        'KPatience' = '󱢡'
        'VSCodium' = '󰨞'
        'vesktop' = ' '

        "private browsing" = ""
        "google" = ""
        "rust" = ""
        "file manager" = ""
        "libreoffice" = ""

        '/(?i).*Locked.*KeePassXC/' = "󰣮"
        "/.*KeePassXC/" = ""
        "menu" = "󰍜"

        "calculator" = ""
        "galculator" = ""

        "music" = ""
        "ncmpcpp" = ""

        "disk usage" = ""
        ".pdf" = ""

        "/(?i)settings/" = ""
        "/(?i)microsoft teams/" = ""

        "Evolution" = ""
        "zoom" = ""
        "(?i)github" = ""
        "(?i)jabber" = ""
        "(?i)thunar" = ""

        "quake" = ""
        "dota2" = "󱇖"

        'neovide' = ""
      '';
    };

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
        export XDG_SESSION_DESKTOP="sway"

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
        #workspaceAutoBackAndForth = true;
        workspaceAutoBackAndForth = false;

        # TODO: fonts.
        /*
          fonts = {
          names = ["pango:Hack" "FontAwesome"];
          size = 12.0;
        };
        */

        #output = {"*" = {bg = "~/wall.jpg fill";};};

        input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:caps_toggle";
            xkb_numlock = "enable";
          };

          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0.3";
          };

          "type:touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
            click_method = "button_areas";
          };
        };

        focus.followMouse = "no";
        focus.mouseWarping = "container";

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
          # exec_always --no-startup-id sworkstyle &> /tmp/sworkstyle.log
          {
            command = "sworkstyle &> /tmp/sworkstyle.log";
            always = true;
          }

          # exec sworkstyle &> /tmp/sworkstyle.log
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

        /*
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
        */
      };

      extraConfig = ''
        #exec --no-startup-id systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP
        #exec --no-startup-id mako &

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
