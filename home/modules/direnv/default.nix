{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.direnv;
in {
  options = {
    module.direnv.enable = mkEnableOption "Enables direnv";
  };

  config = mkIf cfg.enable {
    # direnv
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}