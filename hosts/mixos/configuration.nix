# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  #stylix,
  #impermanence,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example
    #outputs.nixosModules.virtualization

    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # stylix
    inputs.stylix.nixosModules.stylix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Impermanence
    inputs.impermanence.nixosModules.impermanence
    #(inputs.impermanence + "/nixos.nix")

    #../../modules/virtualization.nix
  ];

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # Steam missing deps
      /*
      (final: prev: {
        steam = prev.steam.override ({extraPkgs ? pkgs': [], ...}: {
          extraPkgs = pkgs':
            (extraPkgs pkgs')
            ++ (with pkgs'; [
              libgdiplus
              xwayland
            ]);
        });
      })
      */
    ];
  };

  # Unfree packages.
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;

  # set cpu freq governor (see hardware config)
  #powerManagement.cpuFreqGovernor = "performance";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking = {
    hostName = "mixos";
    useDHCP = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [22];
    nftables.enable = false;

    extraHosts = ''
      192.168.6.32 elma.horizont.local
    '';
  };
  networking.nameservers = ["192.168.1.1#one.one.one.one" "8.8.8.8.#google"];
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    extraConfig = ''
      DNSOverTLS=no
    '';
  };
  systemd.network = {
    enable = true;
    netdevs = {
      "br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };
    };
    networks = {
      # Add all adapters to br0 bridge
      "br0_en-all" = {
        matchConfig.Name = "en*";
        networkConfig = {
          Bridge = "br0";
          LinkLocalAddressing = "no";
        };
        linkConfig.RequiredForOnline = "no";
      };

      "br0" = {
        matchConfig.Name = "br0";
        networkConfig = {
          Address = [
            /*
            "192.168.50.33/24"
            */
            "192.168.1.33/24"
          ];
          IPv4Forwarding = true;
          Gateway = "192.168.1.1";
          LinkLocalAddressing = "no";
        };
        #linkConfig.RequiredForOnline = "no";
      };
    };
  };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.66.66.2/32" "fd42:42:42::2/128"];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/home/aj01/wireguard-keys/privatekey";

      peers = [
        {
          publicKey = "AHK8uBAHN29XfPYJmzh/hjhOkEGuzf/HDZRayR7RlBw=";
          presharedKeyFile = "/home/aj01/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = ["192.168.167.0/24" "192.168.11.0/24" "192.168.6.0/24"];
          endpoint = "79.172.45.20:40414";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Yekaterinburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure X11.
  #services.xserver.enable = true;
  services.xserver = {
    videoDrivers = ["amdgpu"];
    xkbModel = "pc105";
    layout = "us,ru";
    xkbOptions = "grp:caps_toggle";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  console = {
    earlySetup = true;
    font = "ter-powerline-v24n";
    packages = [pkgs.powerline-fonts];
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
    ## Use keys only. Remove if you want to SSH using password (not recommended)
    #passwordAuthentication = false;
  };

  #services.fwupd.enable = true;

  # Disks.
  services.fstrim.enable = true;
  services.udisks2.enable = true;

  systemd.services."zapret" = {
    enable = true;
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    path = [
      pkgs.iptables
      /*
      pkgs.nftables
      */
      pkgs.gawk
      pkgs.procps
    ];
    serviceConfig = {
      Type = "forking";
      Restart = "no";
      KillMode = "none";
      GuessMainPID = "no";
      RemainAfterExit = "no";
      IgnoreSIGPIPE = "no";
      TimeoutSec = "30sec";
      /*
        ExecStart = ''
        ${pkgs.zapret}/bin/zapret start
      '';
      ExecStop = ''
        ${pkgs.zapret}/bin/zapret stop
      '';
      */

      ExecStart = ''
        ${inputs.zapret.packages.x86_64-linux.default}/src/init.d/sysv/zapret start
      '';
      ExecStop = ''
        ${inputs.zapret.packages.x86_64-linux.default}/src/init.d/sysv/zapret stop
      '';
    };
  };

  # Android.
  programs.adb.enable = true;
  # For Android emulator.
  systemd.enableUnifiedCgroupHierarchy = lib.mkForce true;
  # Users
  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aj01 = {
    isNormalUser = true;
    createHome = true;
    home = "/home/aj01";
    description = "Alex Deb";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel" "video" "audio" "realtime" "input" "qemu-libvirtd" "libvirtd" "adbusers" "kvm"];
    hashedPassword = "$6$1gwYNpV/QLfIgPn5$ITN4dMnTAq78kWMthv/SJoeuoWKUmzVIqbNHFFo.CrhWrCR5qnLniOBKdzfc9Mb/qH60EeG7/CcYi/6os5lJJ/";
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    binsh = "${pkgs.zsh}/bin/zsh";
    pathsToLink = ["/share/zsh"];
    shells = with pkgs; [zsh];
    systemPackages = with pkgs; [
      file
      nano
      curl
      bind
      fd
      git
      man-pages
      man-pages-posix
      ripgrep
      wget
      jq

      nix-output-monitor
      home-manager

      alejandra
      sbctl
      ntfs3g
      comma
      atool
      unzip
      zip
      nix-output-monitor
      edk2-uefi-shell
      udisks2
      fontconfig

      dxvk
      vkd3d
      vkd3d-proton
      #inputs.nix-gaming.packages.${pkgs.system}.proton-ge
      steam-run

      # For vscode extensions proper work.
      vscode.fhs

      xwayland

      openvpn

      bridge-utils
      qemu
      swtpm
      edk2
      OVMFFull
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice

      #android-studio
      android-tools
      gvfs
      polkit_gnome
      #inputs.gpt4all.packages.x86_64-linux.gpt4all-chat-avx
      #inputs.gpt4all.packages.x86_64-linux.gpt4all-chat

      inputs.zapret.packages.${pkgs.system}.default
      spoofdpi
      #zapret
    ];

    persistence."/nix/persist" = {
      directories = [
        "/etc/nixos" # bind mounted from /nix/persist/etc/nixos to /etc/nixos
        "/var/log"
        "/var/lib"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
    #persistence."/persist" = {
    #  hideMounts = true;
    #  directories = [
    #    "/var/log"
    #    "/etc/secureboot"
    #    "/var/lib/bluetooth"
    #    "/var/lib/nixos"
    #    "/var/lib/systemd/coredump"
    #  ];
    #};
  };

  # fonts

  fonts = {
    /*
      packages = with pkgs; [
      (nerdfonts.override {fonts = ["Iosevka" "Hack" "FiraCode" "DroidSansMono"];})
      iosevka-bin

      hack-font

      fira-code
      fira-code-symbols

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      openmoji-color

      maple-mono-NF
      (pkgs.callPackage ../../pkgs/mplus-fonts {}) # TODO: do I really need to call it like this?
      (pkgs.callPackage ../../pkgs/balsamiqsans {})
    ];
    */
    /*
    fontconfig = {
      enable = lib.mkDefault true;
      defaultFonts = {
        #monospace = ["M PLUS 1 Code"];
        monospace = ["Iosevka Term"];

        #emoji = ["Noto Color Emoji"];
        emoji = ["OpenMoji Color"];
      };
    };
    */
    fontDir.enable = true;
  };

  stylix = {
    enable = true;
    homeManagerIntegration.followSystem = false;
    homeManagerIntegration.autoImport = false;

    # Either image or base16Scheme is required
    # ls /nix/store/kn5syvn01z6bx59ibchnraa8hnl68ny3-base16-schemes-unstable-2023-05-02/share/themes/
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-city-dark.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "Hack nerd font mono";
      };

      sizes = {
        terminal = 9;
      };
    };

    opacity = {
      terminal = 0.9;
    };
  };

  # programs
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    zsh.enable = true;
    fuse.userAllowOther = true; # impermanence
  };

  services.dbus.implementation = "broker";

  # security
  security = {
    sudo.wheelNeedsPassword = false;
    #polkit.enable = true;
  };
  #Swaylock cannot be unlocked with the correct password
  security.pam.services.swaylock = {};

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

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Thunar
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  virtualisation = {
    vmVariant = {
      virtualisation = {
        memorySize = 8192;
        cores = 4;

        sharedDirectories = {
          home = {
            source = "$HOME";
            target = "/mnt";
          };
        };
      };

      virtualisation.qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=off"
        "-audio pa,model=hda"
      ];

      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      services.interception-tools.enable = lib.mkForce false;
    };

    libvirtd = {
      /*
      qemu.ovmf.package = pkgs.OVMFFull.override {
        secureBoot = true;
        csmSupport = false;
        httpSupport = true;
        tpmSupport = true;
        edk2 = pkgs.edk2.overrideAttrs (oldAttrs: rec {
          version = "202108";

          src = pkgs.fetchFromGitHub {
            owner = "tianocore";
            repo = "edk2";
            rev = "edk2-stable202108";
            fetchSubmodules = true;
            sha256 = "1ps244f7y43afxxw6z95xscy24f9mpp8g0mfn90rd4229f193ba2";
          };

          patches = [
            # Pull upstream fix for gcc-11 build.
            (pkgs.fetchpatch {
              name = "gcc-11-vla.patch";
              url = "https://github.com/google/brotli/commit/0a3944c8c99b8d10cc4325f721b7c273d2b41f7b.patch";
              sha256 = "10c6ibnxh4f8lrh9i498nywgva32jxy2c1zzvr9mcqgblf9d19pj";
              # Apply submodule patch to subdirectory: "a/" -> "BaseTools/Source/C/BrotliCompress/brotli/"
              stripLen = 1;
              extraPrefix = "BaseTools/Source/C/BrotliCompress/brotli/";
            })
          ];
        });
      */
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          })
          .fd
        ];
        #ovmf.packages = [pkgs.OVMFFull];
        /*
          ovmf.packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            csmSupport = false;
            httpSupport = true;
            tpmSupport = true;
          })
          .fd
        ];
        */
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
