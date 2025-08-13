{
  lib,
  config,
  username,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.services.syncthing;
in {
  options = {
    module.services.syncthing.enable = mkEnableOption "Enable syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = username;
      dataDir = "/home/${username}/syncthing";
      configDir = "/home/${username}/.config/syncthing";
    };
  };
}
