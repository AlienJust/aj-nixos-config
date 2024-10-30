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
      package = (
        pkgs.zapret.overrideAttrs (
          finalAttrs: previousAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "bol-van";
              repo = "zapret";
              rev = "v66";
              hash = "sha256-5CrXQ6BhAN4CDWvvGGgiBdSKdZMk4rJMSzHWp+TprGc=";
            };
          }
        )
      );
      params = [
        #"--dpi-desync=disorder --dpi-desync-ttl=1 --dpi-desync-split-pos=3"
        #"--dpi-desync=fake --dpi-desync-repeats=6"
        #"--dpi-desync-any-protocol"

        "--filter-tcp=80 --dpi-desync=fake,split --dpi-desync-ttl=5 --dpi-desync-fake-tls=0x00000000 --dpi-desync-repeats=10 --new --filter-tcp=443 --dpi-desync=fake,split --dpi-desync-ttl=5 --dpi-desync-fake-tls=0x00000000 --dpi-desync-repeats=10 --new --filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=10"

        #конкретно это мой провайдер, с этими параметрами работает у меня либо все, либо почти все.
        #"--dpi-desync=split2 --dpi-desync=fake --dpi-desync-repeats=6 " # youtube
        #"--dpi-desync-any-protocol --dpi-desync=fake" # discord
      ];
    };
  };
}
