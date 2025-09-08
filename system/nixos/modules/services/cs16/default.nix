{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.services.cs16;

  # Локальная сборка образа
  cstrikeImage = pkgs.dockerTools.buildImage {
    name = "cstrike-server";
    tag = "latest";

    # Клонируем репозиторий и используем его Dockerfile
    fromImage = null;

    copyToRoot = pkgs.buildEnv {
      name = "cstrike-root";
      paths = [];
      pathsToLink = ["/"];
    };

    buildCommands = ''
      # Клонируем репозиторий
      git clone https://github.com/CajuCLC/cstrike-docker.git /tmp/cstrike-docker

      # Копируем Dockerfile и скрипты
      cp -r /tmp/cstrike-docker/* .
      rm -rf /tmp/cstrike-docker

      # Собираем образ согласно Dockerfile из репозитория
      echo "Building CS 1.6 server image..."
    '';

    config = {
      Cmd = ["/bin/sh" "-c" "cd /opt/hlds && ./hlds_run -game cstrike +maxplayers 16 +map de_dust2 +sv_lan 0"];
      ExposedPorts = {
        "27015/tcp" = {};
        "27015/udp" = {};
      };
      WorkingDir = "/opt/hlds";
    };
  };
in {
  options.module.services.cs16 = {
    enable = mkEnableOption "Counter-Strike 1.6 Docker container";

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

    autoRemove = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically remove the container when it exits";
    };

    serverParams = mkOption {
      type = types.str;
      default = "+maxplayers 16 +map de_dust2 +sv_lan 0";
      description = "Server startup parameters";
    };

    extraDockerOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--env=SV_PASSWORD=secret" "--volume=/path/to/maps:/opt/hlds/cstrike/maps"];
      description = "Extra options to pass to the docker run command";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;

    # Зависимости для сборки
    environment.systemPackages = with pkgs; [git docker];

    systemd.services.cstrike-docker = {
      description = "Counter-Strike 1.6 Docker Container";
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
        if docker ps -a --filter "name=cstrike-server" --format "{{.Names}}" | grep -q "cstrike-server"; then
          echo "Stopping and removing existing cstrike-server container..."
          docker stop cstrike-server || true
          docker rm cstrike-server || true
        fi

        # Удаляем старый образ если собираем локально
        if ${boolToString cfg.buildImageLocally} && docker images --format "{{.Repository}}" | grep -q "cstrike-server"; then
          echo "Removing old cstrike-server image..."
          docker rmi cstrike-server:latest || true
        fi
      '';

      script =
        if cfg.buildImageLocally
        then ''
          # Собираем образ локально
          echo "Building CS 1.6 server image from GitHub..."

          # Создаем временную директорию для сборки
          BUILD_DIR=$(mktemp -d)
          cd "$BUILD_DIR"

          # Клонируем репозиторий
          git clone https://github.com/CajuCLC/cstrike-docker.git .

          # Собираем Docker образ
          docker build -t cstrike-server:latest .

          # Очищаем
          cd /
          rm -rf "$BUILD_DIR"

          # Запускаем контейнер
          docker run \
            --name cstrike-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            cstrike-server:latest \
            ${cfg.serverParams}
        ''
        else ''
          # Используем образ из DockerHub (если появится)
          docker run \
            --name cstrike-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            cajuclc/cstrike:latest \
            ${cfg.serverParams}
        '';

      preStop = ''
        docker stop cstrike-server || true
      '';
    };

    networking.firewall = {
      enable = true;
      allowedUDPPorts = [cfg.port];
      allowedTCPPorts = [cfg.port];
    };
  };
}
