{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.git;
in {
  options = {
    module.git.enable = mkEnableOption "Enables git";
  };

  config = mkIf cfg.enable {
    # Git config
    /*
    programs.git = {
      enable = true;
      userName = "TheMaxMur";
      userEmail = "muravjev.mak@yandex.ru";

      signing = {
        key = "EC9C10ED7A62D7BDB796B05EEB757CE80A4B2F30";
        signByDefault = true;
      };

      includes = [
        {
          path = "~/Code/work/gitconfig";
          condition = "gitdir:~/Code/work/**";
        }
      ];
    };
    */

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Alexey Debelov";
          email = "alienjustmail@gmail.com";
        };
      };
      #userName = "Alexey Debelov";
      #userEmail = "alienjustmail@gmail.com";
      extraConfig = {
        http = {
          "https://188.226.43.56:62328" = {
            sslCAInfo = "/home/aj01/gitea.crt";
          };
          "https://192.168.11.20:50589" = {
            sslCAInfo = "/home/aj01/gitlab.crt";
          };
          postBuffer = 524288000;
        };
      };
    };
  };
}
