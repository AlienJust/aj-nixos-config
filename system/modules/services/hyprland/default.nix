{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.services.hyprland;
in {
  options = {
    module.services.hyprland.enable = mkEnableOption "Enables hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;

      # Use package from flake:
      #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
}
