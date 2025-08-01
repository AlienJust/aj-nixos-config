{
  config,
  pkgs,
  lib,
  hostname,
  ...
}:
with lib; let
  cfg = config.module.mpd;
  mpd-sacd = pkgs.callPackage "${self}/pkgs/mpd-sacd" {};
in {
  options = {
    module.mpd.enable = mkEnableOption "Enables mpd";
  };

  config = mkIf cfg.enable {
    services.mpd = {
      enable = true;
      package = mpd-sacd;
      musicDirectory = lib.mkMerge [
        (
          lib.mkIf (hostname == "kixos")
          "/home/aj01/music"
        )
        (
          lib.mkIf (hostname == "mixos")
          "/run/media/aj01/hdd2t/.music"
        )
        (
          lib.mkIf (hostname == "wixos")
          "/run/media/aj01/7fbf0bcb-1aaa-4a27-b586-ef167b306d9c/music"
        )
      ];
      extraConfig = ''
        zeroconf_enabled   "no"

        restore_paused     "yes"
        replaygain         "track"

        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }

        audio_output {
          type   "fifo"
          name   "fifo"
          path   "${config.services.mpd.dataDir}/fifo"
          format "44100:16:2"
        }
      '';
    };

    programs.ncmpcpp = {
      enable = true;
      /*
        package = pkgs.ncmpcpp.override {
        visualizerSupport = true;
        taglibSupport = false;
      };
      */
      mpdMusicDir = null; # does not work (not of type `null or path')
      settings = {
        # Visualizer
        visualizer_data_source = "${config.services.mpd.dataDir}/fifo";
        visualizer_in_stereo = "yes";
        visualizer_look = "+|";
        visualizer_output_name = "fifo";
        # visualizer_type = "spectrum";

        # Song list formatting
        song_columns_list_format = builtins.concatStringsSep " " [
          "(6f)[green]{NE}"
          "(45)[white]{t|f:Title}"
          "(20)[]{a}"
          "(25)[cyan]{b}"
          "(5f)[blue]{P}"
          "(7f)[magenta]{l}"
        ];

        # Display lists in column mode by default
        browser_display_mode = "columns";
        search_engine_display_mode = "columns";

        # Faster seeking
        seek_time = 5;

        # More modern UI
        user_interface = "alternative";
      };
    };

    home.packages = with pkgs; [
      mpc_cli
    ];
  };
}
