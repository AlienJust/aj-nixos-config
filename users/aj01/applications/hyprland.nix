{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  home.packages = with pkgs; [jaq xorg.xprop];

  # hyprland config
  wayland.windowManager.hyprland.extraConfig = ''
        # displays
        # monitor = DP-1, 3440x1440@160, 1440x450, 1, bitdepth, 8

        # vertical
        # monitor = HDMI-A-1, 1920x1080@60, 0x0, 1, transform, 1, bitdepth, 8

        # horizontal
        monitor = HDMI-A-1, 1920x1080@60, 0x0, 1, bitdepth, 8

        # workspaces
        workspace = name:1, monitor:HDMI-A-1
        workspace = name:2, monitor:HDMI-A-1
        workspace = name:3, monitor:HDMI-A-1
        workspace = name:4, monitor:HDMI-A-1
        workspace = name:5, monitor:HDMI-A-1
        workspace = name:6, monitor:HDMI-A-1
        workspace = name:7, monitor:HDMI-A-1
        workspace = name:8, monitor:HDMI-A-1
        workspace = name:9, monitor:HDMI-A-1
        workspace = name:10, monitor:HDMI-A-1
        workspace = name:11, monitor:HDMI-A-1
        workspace = name:12, monitor:HDMI-A-1
        workspace = name:13, monitor:HDMI-A-1
        workspace = name:14, monitor:HDMI-A-1
        workspace = name:15, monitor:HDMI-A-1
        workspace = name:16, monitor:HDMI-A-1
        workspace = name:17, monitor:HDMI-A-1
        workspace = name:18, monitor:HDMI-A-1


        # set wallpapers
        # wallpaper ultrawide
        # exec-once = swaybg -o DP-1 -i ~/.local/share/wallpapers/bg1.jpg -m fill
        # wallpaper portrait
        exec-once = swaybg -o HDMI-A-1 -i ~/wall.jpg -m fill

        # panel
        exec-once = eww daemon && eww open bar

        # xdph
        exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

        # inputs
        input {
            kb_layout = us,ru
            kb_options = grp:caps_toggle
            follow_mouse = 1
            #sensitivity = -0.5 # hm
            sensitivity = 0
            repeat_delay = 250
        }

        # general
        general {
            gaps_in = 0
            gaps_out = 0
            border_size = 3
            col.active_border = 0xFF8F8AA8
            col.inactive_border = 0xFF232136
            layout = dwindle
            #layout = master

            cursor_inactive_timeout = 0
            resize_on_border = true
            hover_icon_on_border = true
        }

        # dwindle layout
        dwindle {
            pseudotile = no
            preserve_split = no
            force_split = yes
        }

        # misc
        misc {
            disable_hyprland_logo = true
            vrr = 0
            key_press_enables_dpms = true
            mouse_move_enables_dpms = true
        }

        # animations (why)
        animations {
            enabled = false
        }



        # windows rules
        # fix telegram media preview
        windowrulev2 = float, class:org.telegram.desktop, title:Media viewer

        # fix wine winecfg being cropped
        windowrulev2 = nomaxsize, title:^(Wine configuration)$
        windowrulev2 = forceinput, title:^(Wine configuration)$

        # fix wine dialogs being cropped
        windowrulev2 = minsize 899 556, class:^(battle.net.exe)$, title:^(.*Installation.*)$

        # fix vscode
        windowrulev2=fakefullscreen, class:^(code-url-handler)$

        # games
        windowrulev2 = workspace 5, class:^(wowclassic.exe)$ # wow classic
        windowrulev2 = forceinput, class:^(wowclassic.exe)$ # wow classic
        windowrulev2 = workspace 5, class:^(overwatch.exe)$ # overwatch
        windowrulev2 = forceinput, class:^(overwatch.exe)$ # overwatch
        windowrulev2 = forceinput, class:^(leagueclientux.exe)$ # league of legends
        windowrulev2 = workspace 4, class:^(leagueclientux.exe)$ # league of legends
        windowrulev2 = maxsize 1920 1080, class:^(leagueclientux.exe)$ # league of legends - client
        windowrulev2 = minsize 1920 1080, class:^(leagueclientux.exe)$ # league of legends - client
        windowrulev2 = minsize 1534 831, class:^(riotclientux.exe)$ # league of legends - riot client
        windowrulev2 = maxsize 1534 831, class:^(riotclientux.exe)$ # league of legends - riot client
        windowrulev2 = center, class:^(leagueclientux.exe)$ # league of legends - client
        windowrulev2 = forceinput, class:^(league of legends.exe)$ # league of legends - game
        windowrulev2 = fullscreen, class:^(league of legends.exe)$ # league of legends - game
        windowrulev2 = workspace 5, class:^(league of legends.exe)$ # league of legends` - game

        # application workspaces
        windowrulev2 = workspace 4, class:^(Steam)$
        windowrulev2 = workspace 6, class:^(obs)$
        windowrulev2 = workspace 6, class:^(Spotify)$
        windowrulev2 = workspace 5, title:^(Steam Big Picture)$

        # bindings
        # terminal
        bind = SUPER, Return, exec, foot

        # application launcher
        bind = SUPER, D, exec, anyrun

        # browser
        bind = SUPER, O, exec, firefox

        # colour picker
        bind = SUPER, C, exec, hyprpicker -a

        # kill selected window
        bind = SUPER SHIFT, Q, killactive,

        # quit hyprland
        bind = SUPER SHIFT, E, exec, wlogout

        # fullscreen screen shot
        bind = SUPER, F11, exec, grim -o HDMI-A-1 # fix notification

        # region screenshot
        bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" # fix notification

        # fullscreen video recording

        # region video recording
        # shift ctrl super s?

        bind = SUPER,       SPACE,  focusurgentorlast,
        bind = SUPER SHIFT, SPACE,  togglefloating,

        bind = SUPER,       TAB, layoutmsg, cyclenext
        bind = SUPER SHIFT, TAB, layoutmsg, cycleprev

        # toggle focus to pseudo tiled
        bind = SUPER, P, pseudo,

        # toggle split
        bind = SUPER, S, togglesplit, # dwindle

        # toggle fullscreen

        # move focus with arrow keys
        bind = SUPER, left,  movefocus, l
        bind = SUPER, right, movefocus, r
        bind = SUPER, up,    movefocus, u
        bind = SUPER, down,  movefocus, d

        # preselect with arrow keys
    #    bind = SUPER SHIFT, left, layoutmsg, preselect l
    #    bind = SUPER SHIFT, right, layoutmsg, preselect r
    #    bind = SUPER SHIFT, up, layoutmsg, preselect u
    #    bind = SUPER SHIFT, down, layoutmsg, preselect d

        bind = SUPER SHIFT, left,  movewindow, l
        bind = SUPER SHIFT, right, movewindow, r
        bind = SUPER SHIFT, up,    movewindow, u
        bind = SUPER SHIFT, down,  movewindow, d

        # switch workspaces
        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9
        bind = SUPER, 0, workspace, 10
        bind = SUPER, F1, workspace, 11
        bind = SUPER, F2, workspace, 12
        bind = SUPER, F3, workspace, 13
        bind = SUPER, F4, workspace, 14
        bind = SUPER, F5, workspace, 15
        bind = SUPER, F6, workspace, 16
        bind = SUPER, F7, workspace, 17
        bind = SUPER, F8, workspace, 18

        # send active window to given workspace
        bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
        bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
        bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
        bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
        bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
        bind = SUPER SHIFT, 6, movetoworkspacesilent, 6

        # move and resize windows with mouse
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow

        # Resize submap
        bind = SUPER, R, submap, resize
        submap = resize
          bind  = SUPER, R,      submap, reset
          bind  =      , Escape, submap, reset
          bind  =      , Return, submap, reset
          binde =      , right,  resizeactive, 5 0
          binde =      , left,   resizeactive, -5 0
          binde =      , up,     resizeactive, 0 -5
          binde =      , down,   resizeactive, 0 5
          binde = SHIFT, right,  resizeactive, 100 0
          binde = SHIFT, left,   resizeactive, -100 0
          binde = SHIFT, up,     resizeactive, 0 -100
          binde = SHIFT, down,   resizeactive, 0 100
        submap = reset

        # volume control
        bindl =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
        bindl =, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        # media
        bindl =, XF86AudioNext, exec, playerctl next -i chromium
        bindl =, XF86AudioPrev, exec, playerctl previous -i chromium
        bindl =, XF86AudioPlay, exec, playerctl play-pause -i chromium

        # toggle keyboard layout
        bind=, XF86Calculator, exec, hyprctl switchxkblayout kbdfans-kbd67mkiirgb-v2 next
  '';

  # enable hyprland
  wayland.windowManager.hyprland = {
    enable = true;
  };
}
