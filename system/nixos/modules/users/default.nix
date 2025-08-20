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
    sops = {
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = "/nix/persist/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
      secrets = {
        hash = {
          neededForUsers = true;
          sopsFile = ../../../../secrets/secrets.yaml;
        };
      };
    };

    # DEBUG.
    /*
    environment.etc = {
      # Creates /etc/my-config.conf
      "my-config.conf" = {
        text = ''
          # This is the content of my-config.conf
          setting1 = ${config.sops.secrets.hash.path}
          setting2 = value2
        '';
        mode = "0644"; # Permissions for the file
      };
    };
    */

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
          #shell = pkgs.fish;
          shell = pkgs.zsh;
          group = "${username}";
          createHome = true;
          description = "${username}";
          isSystemUser = true;
          hashedPasswordFile = config.sops.secrets.hash.path;

          extraGroups = [
            "audio"
            #"networkmanager"
            "wheel"
            "docker"
            "video"
            "realtime"
            "input"
            "dialout"
            "qemu-libvirtd"
            "libvirtd"
            "yggdrasil"
          ];
        };

        root = {
          shell = pkgs.zsh;
          hashedPasswordFile = config.sops.secrets.hash.path;
        };
      };
    };
  };
}
