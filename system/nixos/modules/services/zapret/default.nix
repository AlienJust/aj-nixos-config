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
      udpPorts = ["443" "19294:19344" "50000:50100"];

      #udpPorts = ["443"];
      #tcpPorts = ["80" "443" "2053" "2083" "2087" "2096" "8443"];

      params = [
        # Блок 1: QUIC / HTTP3 (Общие списки)
        "--filter-udp=443 --hostlist=${./lists/list-general.txt} --hostlist=${./lists/list-general-user.txt} --hostlist-exclude=${./lists/list-exclude.txt} --hostlist-exclude=${./lists/list-exclude-user.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --ipset-exclude=${./lists/ipset-exclude-user.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"

        "--new"
        # Блок 2: Discord Голос (Исправлены дефисы на двоеточия!)
        "--filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=${./bin/quic_initial_dbankcloud_ru.bin} --dpi-desync-fake-stun=${./bin/quic_initial_dbankcloud_ru.bin} --dpi-desync-repeats=6"

        "--new"
        # Блок 3: Discord Media (Картинки/Стримы) по специфичным TCP-портам
        "--filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

        /*
          "--new"
        # Блок 4: Сервисы Google (Специфичный обход)
        "--filter-tcp=443 --hostlist=${./lists/list-google.txt} --ip-id=zero --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"
        */
        /*
          "--new"
        # Блок 4: Сервисы Google (Модифицированный обход через split2)
        "--filter-tcp=443 --hostlist=${./lists/list-google.txt} --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq,md5sig --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"
        */

        # WORKS

        #"--new"
        ## Блок 4: Сервисы Google (Обход через disorder)
        #"--filter-tcp=443 --hostlist=${./lists/list-google.txt} --dpi-desync=disorder --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=6"

        "--new"
        # Блок 4А: Быстрая загрузка интерфейса YouTube
        "--filter-tcp=443 --hostlist=${./lists/list-youtube-ui.txt} --dpi-desync=disorder --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq --dpi-desync-repeats=6"

        "--new"
        # Блок 4Б: Высокая скорость для видеосерверов (Опережающий сплит)
        "--filter-tcp=443 --hostlist=${./lists/list-youtube-video.txt} --dpi-desync=split2 --dpi-desync-split-pos=midsld --dpi-desync-fooling=badseq --dpi-desync-repeats=6"

        #"--new"
        ## Блок 4: Ваша рабочая схема Disorder, доработанная для разблокировки скорости видео
        #"--filter-tcp=443 --hostlist=${./lists/list-google.txt} --dpi-desync=disorder --dpi-desync-split-pos=1 --dpi-desync-fooling=badseq,md5sig --dpi-desync-repeats=6 --wsize=4"

        "--new"
        # Блок 5: Общие списки сайтов TCP (Убран дубликат фейка stun.bin)
        "--filter-tcp=80,443 --hostlist=${./lists/list-general.txt} --hostlist=${./lists/list-general-user.txt} --hostlist-exclude=${./lists/list-exclude.txt} --hostlist-exclude=${./lists/list-exclude-user.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --ipset-exclude=${./lists/ipset-exclude-user.txt} --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin} --dpi-desync-fake-http=${./bin/tls_clienthello_max_ru.bin}"

        "--new"
        # Блок 6: Обход по IP-сетям (Режим ipset-all) для UDP
        "--filter-udp=443 --ipset=${./lists/ipset-all.txt} --hostlist-exclude=${./lists/list-exclude.txt} --hostlist-exclude=${./lists/list-exclude-user.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --ipset-exclude=${./lists/ipset-exclude-user.txt} --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"

        "--new"
        # Блок 7: Обход по IP-сетям для TCP (Убран дубликат фейка stun.bin)
        "--filter-tcp=80,443,8443 --ipset=${./lists/ipset-all.txt} --hostlist-exclude=${./lists/list-exclude.txt} --hostlist-exclude=${./lists/list-exclude-user.txt} --ipset-exclude=${./lists/ipset-exclude.txt} --ipset-exclude=${./lists/ipset-exclude-user.txt} --dpi-desync=fake,multisplit --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=1000 --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin} --dpi-desync-fake-http=${./bin/tls_clienthello_max_ru.bin}"
      ];
    };
  };
}
