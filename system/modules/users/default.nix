{
  self,
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.module.users;
in {
  options = {
    module.users.enable = mkEnableOption "Enables users";
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;

      users = {
        ${username} = {
          isNormalUser = true;
          description = "${username}";
          home = "/home/${username}";
          #shell = pkgs.fish;
          shell = pkgs.zsh;
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
            "kvm"

            "adbusers"
            #"acme"
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
