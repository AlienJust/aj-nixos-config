{
  self,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.module.services.rudpt;
  # Импортируем пакет из  директории
  rudpt = pkgs.callPackage "${self}/pkgs/rudpt" {};
in {
  options.module.services.rudpt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Включает службу rudpt, собранную из локального пакета.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Дополнительные аргументы командной строки для rudpt.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.rudpt = {
      description = "Rudpt Service";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        ExecStartPre = ''
          ${pkgs.coreutils}/bin/mkdir -p /var/lib/rudpt
          ${pkgs.coreutils}/bin/cp -n ${rudpt}/share/rudpt/config.toml /var/lib/rudpt/config.toml
        '';
        # ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/rudpt";
        ExecStart = "${rudpt}/bin/rudpt ${concatStringsSep " " config.module.services.rudpt.extraArgs}";
        Restart = "on-failure";
        RestartSec = 5;
        # Если нужна рабочая директория:
        WorkingDirectory = "/var/lib/rudpt";
        # Можно добавить окружение:
        Environment = [
          "RUST_LOG=info"
        ];
      };
    };

    # Установим пакет в систему
    environment.systemPackages = [rudpt];

    # Создадим директорию данных
    systemd.tmpfiles.rules = [
      "d /var/lib/my-rust-app 0755 root root -"
    ];
  };
}
