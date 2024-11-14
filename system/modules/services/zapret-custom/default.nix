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
    ];
  };
}
