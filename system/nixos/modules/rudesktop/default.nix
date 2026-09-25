{
  self,
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.rudesktop;
  rudesktop = pkgs.callPackage "${self}/pkgs/rudesktop" {};
in {
  options = {
    module.rudesktop.enable = mkEnableOption "Enables rudesktop";
  };

  config = mkIf cfg.enable {
    # 1. Добавляем сам графический клиент в систему
    environment.systemPackages = [rudesktop];

    # 2. Разрешаем unfree-лицензию конкретно для этого пакета
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["rudesktop"];

    # 3. Создаем системную службу, которую не мог найти systemctl
    systemd.services.rudesktop = {
      description = "RuDesktop Remote Desktop Daemon";

      # Служба запустится после поднятия сети и экранного менеджера (GDM/SDDM/LightDM)
      after = ["network.target" "display-manager.service"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        # Вызываем бинарник из созданного нами ранее symlink в $out/bin
        ExecStart = "${rudesktop}/bin/rudesktop --service";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
