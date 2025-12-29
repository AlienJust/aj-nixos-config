{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.services.zapret;
in {
  options = {
    module.services.zapret.enable = mkEnableOption "Enable zapret";
  };

  config = mkIf cfg.enable {
    services.zapret = {
      enable = true;

      # package = (
      #   pkgs.zapret.overrideAttrs (
      #     finalAttrs: previousAttrs: {
      #       src = pkgs.fetchFromGitHub {
      #         owner = "bol-van";
      #         repo = "zapret";
      #         rev = "v66";
      #         hash = "sha256-5CrXQ6BhAN4CDWvvGGgiBdSKdZMk4rJMSzHWp+TprGc=";
      #       };
      #     }
      #   )
      # );

      udpSupport = true;
      udpPorts = ["443" "19294-19344" "50000-50100"];
      #tcpPorts = ["443" "2053" "2083" "2087" "2096" "8443"];

      params = [
        #"--dpi-desync=disorder --dpi-desync-ttl=1 --dpi-desync-split-pos=3"
        #"--dpi-desync=fake --dpi-desync-repeats=6"
        #"--dpi-desync-any-protocol"

        #"--filter-tcp=80 --dpi-desync=fake,split --dpi-desync-ttl=5 --dpi-desync-fake-tls=0x00000000 --dpi-desync-repeats=10 --new --filter-tcp=443 --dpi-desync=fake,split --dpi-desync-ttl=5 --dpi-desync-fake-tls=0x00000000 --dpi-desync-repeats=10 --new --filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=10"

        # "--filter-tcp=80"
        # "--dpi-desync=fake,split"
        # "--dpi-desync-ttl=5"
        # "--dpi-desync-fake-tls=0x00000000"
        # "--dpi-desync-repeats=10"
        # "--new"
        # "--filter-tcp=443"
        # "--dpi-desync=fake,split"
        # "--dpi-desync-ttl=5"
        # "--dpi-desync-fake-tls=0x00000000"
        # "--dpi-desync-repeats=10"
        # "--new"
        # "--filter-udp=443"
        # "--dpi-desync=fake"
        # "--dpi-desync-repeats=10"

        #конкретно это мой провайдер, с этими параметрами работает у меня либо все, либо почти все.
        #"--dpi-desync=split2 --dpi-desync=fake --dpi-desync-repeats=6 " # youtube
        #"--dpi-desync-any-protocol --dpi-desync=fake" # discord

        # "--filter-tcp=80"
        # "--dpi-desync=fake,split2"
        # "--dpi-desync-fooling=md5sig"
        # "--new"
        # "--filter-tcp=443"
        # "--dpi-desync=fake,disorder2"
        # "--dpi-desync-fooling=md5sig"
        # "--new"
        # "--filter-udp=443"
        # "--dpi-desync=fake"
        # "--dpi-desync-repeats=6"

        # "--dpi-desync-autottl=3"
        # "--wssize 1:6"
        # "--dpi-desync-fake-tls=0x00000000"
        # "--dpi-desync-split-pos=1"
        # "--dpi-desync=syndata,fake,split2"
        # "--dpi-desync-repeats=6"
        # "--dpi-desync-fooling=md5sig"
        # "--new"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=fake,split --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

        #"--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        #"--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        #"--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        #"--filter-tcp=443 --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=${./bin/tls_clienthello_www_google_com.bin}"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=split --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=8 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=fake,split2 --dpi-desync-repeats=6 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-l3=ipv4 --filter-tcp=443 --dpi-desync=syndata"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
        # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

        # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-fooling=md5sig --new"
        # "--filter-tcp=443 --dpi-desync=fake,disorder2 --dpi-desync-fooling=md5sig --new"
        # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6"

        #"--dpi-desync=split2 --dpi-desync-split-pos=4"

        /*

        "--filter-tcp=80"
        "--dpi-desync=fake,split"
        "--dpi-desync-ttl=5"
        "--dpi-desync-fake-tls=0x00000000"
        "--dpi-desync-repeats=10"

        "--new"

        "--filter-tcp=443"
        "--dpi-desync=fake,split"
        "--dpi-desync-ttl=5"
        "--dpi-desync-fake-tls=0x00000000"
        "--dpi-desync-repeats=10"

        "--new"

        "--filter-udp=443"
        "--dpi-desync=fake"
        "--dpi-desync-repeats=10"
        */

        /*
        # ALT3
        "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        "--new"
        "--filter-tcp=80 --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig"
        "--new"
        "--filter-tcp=443 --dpi-desync=fakedsplit --dpi-desync-split-pos=1 --dpi-desync-autottl --dpi-desync-fooling=badseq --dpi-desync-repeats=8"
        "--new"
        "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        */

        # ALT4
        /*
        "--filter-udp=443 --hostlist=${./lists/list-general.txt} --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        "--new"
        "--filter-tcp=443 --hostlist=${./lists/list-google.txt} --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"
        "--new"
        "--filter-tcp=80,443 --hostlist=${./lists/list-general.txt} --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"
        "--new"
        "--filter-udp=443 --ipset=${./lists/ipset-all.txt} --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        */

        # ALT5
        "--filter-udp=443 --hostlist=${./lists/list-general.txt} --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        "--new"
        "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=${./bin/quic_initial_www_google_com.bin} --dpi-desync-fake-stun=${./bin/quic_initial_www_google_com.bin} --dpi-desync-repeats=6"
        "--new"
        "--filter-l3=ipv4 --filter-tcp=443,2053,2083,2087,2096,8443 --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=syndata,multidisorder"
        "--new"
        "--filter-udp=443 --ipset=${./lists/ipset-all.txt} --hostlist-exclude=${./lists/list-exclude.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"
        "--new"
        #"--filter-udp=%GameFilter% --ipset=${./lists/ipset-all.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=14 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=${./bin/quic_initial_www_google_com.bin} --dpi-desync-cutoff=n3"
      ];
      /*
      whitelist = [
        "googlevideo.com"
        "youtu.be"
        "youtube.com"
        "youtubei.googleapis.com"
        "googlevideo.com"
        "youtu.be"
        "youtube.com"
        "youtubei.googleapis.com"
        "youtubeembeddedplayer.googleapis.com"
        "ytimg.l.google.com"
        "ytimg.com"
        "jnn-pa.googleapis.com"
        "youtube-nocookie.com"
        "youtube-ui.l.google.com"
        "yt-video-upload.l.google.com"
        "wide-youtube.l.google.com"
        "youtubekids.com"
        "ggpht.com"
        "discord.com"
        "gateway.discord.gg"
        "cdn.discordapp.com"
        "discordapp.net"
        "discordapp.com"
        "discord.gg"
        "media.discordapp.net"
        "images-ext-1.discordapp.net"
        "discord.app"
        "discord.media"
        "discordcdn.com"
        "discord.dev"
        "discord.new"
        "discord.gift"
        "discordstatus.com"
        "dis.gd"
        "discord.co"
        "discord-attachments-uploads-prd.storage.googleapis.com"
        "7tv.app"
        "7tv.io"
        "10tv.app"
      ];
      */
    };
  };
}
