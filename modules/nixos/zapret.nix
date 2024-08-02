/*
MUST BE CALLED LIKE NIX OS MODULE:
       (import ./modules/nixos/zapret.nix
         {
           wan = "br0";
           qnum = 200;
         })
*/
{
  qnum,
  wan,
  ...
}: {
  config,
  pkgs,
  ...
}: {
  networking = {
    firewall = {
      extraCommands = ''
        iptables -t mangle -I POSTROUTING -o "${wan}" -p tcp -m multiport --dports 80,443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${toString qnum} --queue-bypass
      '';
    };
  };
  systemd = {
    services = {
      zapret = {
        description = "zapret service";
        wantedBy = ["multi-user.target"];
        requires = ["network.target"];
        serviceConfig = {
          ExecStart = "${pkgs.zapret}/bin/nfqws --pidfile=/tmp/nfqws.pid --dpi-desync=disorder --dpi-desync-ttl=1 --dpi-desync-split-pos=3 --qnum=${toString qnum}";
          Type = "forking";
          PIDFile = "/tmp/nfqws.pid";
          ExecReload = "/bin/kill -HUP $MAINPID";
          Restart = "always";
          RestartSec = "5s";
        };
      };
    };
  };
  /*
  systemd.services."zapret" = {
    enable = true;
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    path = [
      pkgs.iptables
      pkgs.gawk
      pkgs.procps
    ];
    serviceConfig = {
      Type = "forking";
      Restart = "no";
      KillMode = "none";
      GuessMainPID = "no";
      RemainAfterExit = "no";
      IgnoreSIGPIPE = "no";
      TimeoutSec = "30sec";

      ExecStart = ''
        ${inputs.zapret.packages.x86_64-linux.default}/src/init.d/sysv/zapret start
      '';
      ExecStop = ''
        ${inputs.zapret.packages.x86_64-linux.default}/src/init.d/sysv/zapret stop
      '';
    };
  };
  */
}
