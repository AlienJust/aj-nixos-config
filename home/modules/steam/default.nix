{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.module.steam;
in {
  options = {
    module.steam.enable = mkEnableOption "Enables steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
  };
}
