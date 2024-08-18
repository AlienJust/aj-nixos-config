{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.module.games;
in {
  options = {
    module.games.enable = mkEnableOption "Enables games";
  };

  config = mkIf cfg.enable {
    programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    /*
    package = pkgs.steam.override {
      extraLibraries = p:
        with p; [
          (lib.getLib xwayland)
          (lib.getLib dconf)
          (lib.getLib gvfs)
        ];
    };
    */
  };
  programs.gamemode.enable = true;
  };
}




