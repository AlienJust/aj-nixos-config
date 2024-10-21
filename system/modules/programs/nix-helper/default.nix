{
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.module.programs.nh;
in {
  options = {
    module.programs.nh.enable = mkEnableOption "Enable Nix Helper";
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${username}/src/aj-nixos-config";

      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 10";
      };
    };
  };
}
