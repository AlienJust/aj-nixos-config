{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.module.services.cs16;
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

    disableVAC = mkOption {
      type = types.bool;
      default = true;
      description = "Disable Steam VAC (Valve Anti-Cheat)";
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
      description = "Enable LAN mode (sv_lan)";
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

    autoRemove = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically remove the container when it exits";
    };

    extraDockerOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["--volume=/path/to/maps:/opt/hlds/cstrike/maps"];
      description = "Extra options to pass to the docker run command";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
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
          (optionalString (cfg.serverPassword != null) "+sv_password ${cfg.serverPassword}")
          (optionalString (cfg.rconPassword != null) "+rcon_password ${cfg.rconPassword}")
        ];
      in
        if cfg.buildImageLocally
        then ''
          # Собираем образ локально
          echo "Building CS 1.6 server image from GitHub..."

          BUILD_DIR=$(mktemp -d)
          cd "$BUILD_DIR"
          git clone https://github.com/CajuCLC/cstrike-docker.git .

          # Собираем Docker образ
          docker build -t cstrike-server:latest .

          cd /
          rm -rf "$BUILD_DIR"

          # Запускаем контейнер с отключенным VAC
          docker run \
            --name cstrike-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            cstrike-server:latest \
            ${insecureFlag} -game cstrike ${toString serverParams}
        ''
        else ''
          # Используем образ из DockerHub
          docker run \
            --name cstrike-server \
            --hostname "${cfg.hostname}" \
            -p ${toString cfg.port}:27015/udp \
            -p ${toString cfg.port}:27015/tcp \
            ${optionalString cfg.autoRemove "--rm"} \
            ${concatStringsSep " " cfg.extraDockerOptions} \
            cajuclc/cstrike:latest \
            ${insecureFlag} -game cstrike ${toString serverParams}
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
