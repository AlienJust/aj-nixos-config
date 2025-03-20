{
  self,
  pkgs,
  lib,
  config,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.users;
in {
  options = {
    module.users.enable = mkEnableOption "Enables users";
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;

      groups = {
        ${username} = {
          gid = 1000;
        };
      };

      users = {
        ${username} = {
          uid = 1000;
          home = "/home/${username}";
          shell = pkgs.fish;
          group = "${username}";
          createHome = true;
          description = "${username}";
          isSystemUser = true;
          #hashedPasswordFile = "${self}/secrets/hashes/${username}.hash";
          hashedPassword = "$6$1gwYNpV/QLfIgPn5$ITN4dMnTAq78kWMthv/SJoeuoWKUmzVIqbNHFFo.CrhWrCR5qnLniOBKdzfc9Mb/qH60EeG7/CcYi/6os5lJJ/"; # TODO: replace with hashedPasswordFile

          extraGroups = [
            "audio"
            #"networkmanager"
            "wheel"
            "docker"
            "video"
            "realtime"
            "input"
            "qemu-libvirtd"
            "libvirtd"
            "yggdrasil"
          ];
        };

        root = {
          shell = pkgs.zsh;
          #hashedPasswordFile = "${self}/secrets/hashes/root.hash";
          hashedPassword = "$6$1gwYNpV/QLfIgPn5$ITN4dMnTAq78kWMthv/SJoeuoWKUmzVIqbNHFFo.CrhWrCR5qnLniOBKdzfc9Mb/qH60EeG7/CcYi/6os5lJJ/"; # TODO: replace with hashedPasswordFile
        };
      };
    };
  };
}
