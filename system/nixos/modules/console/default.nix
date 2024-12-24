{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.module.console;
in {
  options = {
    module.console.enable = mkEnableOption "Enables console";
  };

  config = mkIf cfg.enable {
    console = {
      earlySetup = true;
      font = "ter-powerline-v24n";
      packages = [pkgs.powerline-fonts];
      useXkbConfig = true;
    };
  };
}


