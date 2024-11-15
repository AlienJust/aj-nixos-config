{...}: {
  disabledModules = ["services/networking/zapret.nix"];

  imports = [
    ./nixpkgs.nix
  ];

  services.zapret = {
    enable = true;

    params = [
      #"--dpi-desync=fake,split2 --dpi-desync-ttl=5 --domcase --dpi-desync-fooling=md5sig"
      #"--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-repeats=6"

      # "--dpi-desync-autottl=3"
      # "--wssize 1:6"
      # "--dpi-desync-fake-tls=0x00000000"
      # "--dpi-desync-split-pos=1"
      # "--dpi-desync=syndata,fake,split2"
      # "--dpi-desync-repeats=6"
      # "--dpi-desync-fooling=md5sig"

      # works on mixos
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

      # "--dpi-desync=syndata,fake,split2"
      # "--dpi-desync-split-pos=1"
      # "--dpi-desync-autottl=3"
      # "--dpi-desync-fooling=md5sig"
      # "--dpi-desync-ttl=5"
      # "--dpi-desync-fake-tls=0x00000000"
      # "--dpi-desync-repeats=10"
      # "--wssize 1:6"

      # "--filter-tcp=80"
      # "--dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig"

      # "--new"
      # "--filter-tcp=443"
      # "--dpi-desync=fake,split --dpi-desync-autottl=2 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

      # "--new"
      # "--filter-udp=443"
      # "--dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin}"

      # "--new"
      # "--filter-udp=50000-50100"
      # "--dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6"

      # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
      # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
      # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
      # "--filter-tcp=443 --dpi-desync=fake,split --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls=${./bin/tls_clienthello_www_google_com.bin}"

      # "--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=${./bin/quic_initial_www_google_com.bin} --new"
      # "--filter-udp=50000-50100 --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6 --new"
      # "--filter-tcp=80 --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new"
      # "--filter-tcp=443 --dpi-desync=split2 --dpi-desync-split-seqovl=652 --dpi-desync-split-pos=2 --dpi-desync-split-seqovl-pattern=${./bin/tls_clienthello_www_google_com.bin}"

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
    ];
  };
}
