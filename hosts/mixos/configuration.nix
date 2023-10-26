# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
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
  ];

  stylix = {
    homeManagerIntegration.followSystem = false;
    homeManagerIntegration.autoImport = false;

    # Either image or base16Scheme is required
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerdfonts;
        name = "hack nerd font mono";
      };

      sizes = {
        terminal = 10;
      };
    };

    opacity = {
      terminal = 0.9;
    };
  };

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
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
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

  networking.hostName = "mixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ 10.66.66.2/32" "fd42:42:42::2/128 ];
      # dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/home/aj01/wireguard-keys/privatekey";
      
      peers = [
        {
          publicKey = "AHK8uBAHN29XfPYJmzh/hjhOkEGuzf/HDZRayR7RlBw=";
          presharedKeyFile = "/home/aj01/wireguard-keys/preshared_from_peer0_key";
          allowedIPs = [ "192.168.167.0/24" "192.168.11.0/24" ];
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

  # Configure keymap in X11
  services.xserver = {
    xkbModel = "pc105";
    layout = "us,ru";
    xkbOptions = "grp:caps_toggle";
  };

  console = {
    earlySetup = true;
    font = "ter-powerline-v24n";
    packages = [pkgs.powerline-fonts];
    useXkbConfig = true;
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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

  #services.fstrim.enable = true;

  #services.fwupd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aj01 = {
    isNormalUser = true;
    createHome = true;
    home = "/home/aj01";
    description = "Alex Deb";
    shell = pkgs.zsh;
    group = "users";
    extraGroups = ["wheel" "video" "audio" "realtime" "input"];
    hashedPassword = "$6$1gwYNpV/QLfIgPn5$ITN4dMnTAq78kWMthv/SJoeuoWKUmzVIqbNHFFo.CrhWrCR5qnLniOBKdzfc9Mb/qH60EeG7/CcYi/6os5lJJ/";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
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
      fd
      git
      man-pages
      man-pages-posix
      ripgrep
      wget
      jq
      home-manager
      alejandra
      sbctl
      ntfs3g
      comma
      atool
      unzip
      nix-output-monitor
      edk2-uefi-shell
      udisks2
      fontconfig
      xwayland
    ];

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
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Iosevka" "FiraCode" "DroidSansMono"];})
      fira-code
      fira-code-symbols
      iosevka-bin
      openmoji-color
      noto-fonts
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      maple-mono-NF
      (pkgs.callPackage ../../pkgs/mplus-fonts {}) # TODO: do I really need to call it like this?
      (pkgs.callPackage ../../pkgs/balsamiqsans {})
    ];
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

  # programs
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    zsh.enable = true;
    fuse.userAllowOther = true; # impermanence
  };

  # security
  security = {
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  programs.gamemode.enable = true;

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
