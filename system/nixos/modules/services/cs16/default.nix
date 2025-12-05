{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.services.cs16-server;

  # Создаем скрипт для запуска сервера с правильными параметрами
  startupScript = pkgs.writeShellScript "cs16-start" ''
    #!/bin/sh
    #cd /opt/hlds

    # Базовые параметры
    PARAMS="-game cstrike +maxplayers ${toString cfg.maxPlayers} +map ${cfg.defaultMap} +sv_lan ${
      if cfg.lanMode
      then "1"
      else "0"
    } +hostname '${cfg.serverName}'"

    # Добавляем опциональные параметры
    ${optionalString (cfg.serverPassword != null) "PARAMS=\"\$PARAMS +sv_password ${cfg.serverPassword}\""}
    ${optionalString (cfg.rconPassword != null) "PARAMS=\"\$PARAMS +rcon_password ${cfg.rconPassword}\""}
    ${optionalString cfg.disableVAC "PARAMS=\"-insecure \$PARAMS\""}

    # Запускаем сервер
    echo "Starting CS 1.6 server with parameters: \$PARAMS"
    exec ./hlds_run \$PARAMS
  '';
in {
  options.module.services.cs16-server = {
    enable = mkEnableOption "Counter-Strike 1.6 Server from AlienJust/cs-16-server";

    buildImageLocally = mkOption {
      type = types.bool;
      default = true;
      description = "Build Docker image locally from GitHub repository";
    };

    hostname = mkOption {
      type = types.str;
      default = "cs16-server";
      description = "Hostname for the container";
    };

    port = mkOption {
      type = types.port;
      default = 27015;
      description = "Port for the CS 1.6 server";
    };

    disableVAC = mkOption {
      type = types.bool;
      default = true;
      description = "Disable Steam VAC (Valve Anti-Cheat) using -insecure flag";
    };

    maxPlayers = mkOption {
      type = types.int;
      default = 16;
      description = "Maximum number of players";
    };

    defaultMap = mkOption {
      type = types.str;
      default = "de_dust2";
      description = "Default map to start with";
    };

    lanMode = mkOption {
      type = types.bool;
      default = false;
      description = "Enable LAN mode (sv_lan 1)";
    };

    serverPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Server password (optional)";
    };

    rconPassword = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "RCON password (optional)";
    };

    serverName = mkOption {
      type = types.str;
      default = "NixOS CS 1.6 Server";
      description = "Server name that appears in server browser";
    };

    autoRemove = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically remove the container when it exits";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/cs16-server";
      description = "Directory for persistent server data";
    };

    extraDockerOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--env=TZ=Europe/Moscow" "--restart=unless-stopped"];
      description = "Extra options to pass to the docker run command";
    };

    useDockerCompose = mkOption {
      type = types.bool;
      default = false;
      description = "Use docker-compose instead of direct docker run";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = with pkgs; [git docker] ++ optional cfg.useDockerCompose docker-compose;

    # Создаем директорию для данных
    system.activationScripts.cs16-server-dirs = ''
      mkdir -p ${cfg.dataDir}/cstrike
      mkdir -p ${cfg.dataDir}/cstrike/{maps,logs,addons}
      chmod 755 ${cfg.dataDir}
      chmod -R 755 ${cfg.dataDir}/cstrike
    '';

    systemd.services.cs16-server = mkIf (!cfg.useDockerCompose) {
      description = "Counter-Strike 1.6 Server from AlienJust/cs-16-server";
      after = ["network.target" "docker.service"];
      requires = ["docker.service"];
      wantedBy = ["multi-user.target"];

      path = with pkgs; [git docker];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "10s";
      };

      preStart = ''
        # Удаляем старый контейнер если существует
        if docker ps -a --filter "name=cs16-server" --format "{{.Names}}" | grep -q "cs16-server"; then
          echo "Stopping and removing existing cs16-server container..."
          docker stop cs16-server || true
          docker rm cs16-server || true
        fi

        # Удаляем старый образ если собираем локально
        if ${boolToString cfg.buildImageLocally} && docker images --format "{{.Repository}}" | grep -q "cs16-server"; then
          echo "Removing old cs16-server image..."
          docker rmi cs16-server:latest || true
        fi
      '';

      script = let
        insecureFlag =
          if cfg.disableVAC
          then "-insecure"
          else "";
        serverParams = [
          "+maxplayers ${toString cfg.maxPlayers}"
          "+map ${cfg.defaultMap}"
          "+sv_lan ${
            if cfg.lanMode
            then "1"
            else "0"
          }"
          "+hostname \"${cfg.serverName}\""
          (optionalString (cfg.serverPassword != null) "+sv_password ${cfg.serverPassword}")
          (optionalString (cfg.rconPassword != null) "+rcon_password ${cfg.rconPassword}")
        ];
        serverParamsStr = toString serverParams;
      in
        if cfg.buildImageLocally
        then ''
          # Собираем образ локально из AlienJust/cs-16-server
          echo "Building CS 1.6 server image from https://github.com/AlienJust/cs-16-server.git..."

          BUILD_DIR=$(mktemp -d)
          cd "$BUILD_DIR"
          git clone https://github.com/AlienJust/cs-16-server.git .

          # Копируем скрипт запуска в Dockerfile директорию
          cp ${startupScript} start_server.sh
          chmod +x start_server.sh

          # Собираем Docker образ
          docker build -t cs16-server:latest .

          cd /
          rm -rf "$BUILD_DIR"

          # Запускаем контейнер
          docker run \
            --name cs16-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            -v ${cfg.dataDir}/cstrike:/opt/hlds/cstrike \
            -v ${startupScript}:/start_server.sh \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            cs16-server:latest
        ''
        # cs16-server:latest \
        # /bin/sh /start_server.sh
        # /bin/sh /opt/hlds/start_server.sh
        # cs16-server:latest \
        # ${insecureFlag} -game cstrike ${serverParamsStr}
        else ''
          # Используем образ из DockerHub
          docker run \
            --name cs16-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            -v ${cfg.dataDir}/cstrike:/opt/hlds/cstrike \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            AlienJust/cs-16-server:latest \
            ${insecureFlag} -game cstrike ${serverParamsStr}
        '';

      preStop = ''
        docker stop cs16-server || true
      '';
    };

    # Docker-compose вариант
    systemd.services.cs16-server-compose = mkIf cfg.useDockerCompose {
      description = "Counter-Strike 1.6 Server with docker-compose";
      after = ["network.target" "docker.service"];
      requires = ["docker.service"];
      wantedBy = ["multi-user.target"];

      path = with pkgs; [git docker docker-compose];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "${cfg.dataDir}";
      };

      preStart = ''
        mkdir -p ${cfg.dataDir}
        cd ${cfg.dataDir}

        # Создаем docker-compose.yml
        cat > docker-compose.yml << EOF
        version: '3.8'
        services:
          cs16-server:
            ${
          if cfg.buildImageLocally
          then ''            build:
                              context: .
                              dockerfile: Dockerfile''
          else ''image: AlienJust/cs-16-server:latest''
        }
            container_name: cs16-server
            hostname: "${cfg.hostname}"
            ports:
              - "${toString cfg.port}:27015/udp"
              - "${toString cfg.port}:27015/tcp"
            volumes:
              - "${cfg.dataDir}/cstrike:/opt/hlds/cstrike"
            restart: unless-stopped
            command: [
              ${
          if cfg.disableVAC
          then "\"-insecure\","
          else ""
        }
              "-game", "cstrike",
              "+maxplayers", "${toString cfg.maxPlayers}",
              "+map", "${cfg.defaultMap}",
              "+sv_lan", "${
          if cfg.lanMode
          then "1"
          else "0"
        }",
              "+hostname", "${cfg.serverName}"
              ${optionalString (cfg.serverPassword != null) '', "+sv_password", "${cfg.serverPassword}"''}
              ${optionalString (cfg.rconPassword != null) '', "+rcon_password", "${cfg.rconPassword}"''}
            ]
            ${concatStringsSep "\n    " cfg.extraDockerOptions}
        EOF

        # Клонируем репозиторий если собираем локально
        if ${boolToString cfg.buildImageLocally} && [ ! -d .git ]; then
          git clone https://github.com/AlienJust/cs-16-server.git .
        elif ${boolToString cfg.buildImageLocally}; then
          git pull origin main
        fi

        # Останавливаем старый контейнер
        docker-compose down || true
      '';

      script = ''
        cd ${cfg.dataDir}
        docker-compose up -d ${optionalString cfg.buildImageLocally "--build"}
      '';

      postStop = ''
        cd ${cfg.dataDir}
        docker-compose down
      '';
    };

    networking.firewall = {
      enable = true;
      allowedUDPPorts = [cfg.port];
      allowedTCPPorts = [cfg.port];
    };
  };
}
