{
  description = "AJ nix config";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    trustedUsers = ["@wheel" "aj01" "root"];
    substituters = [
      # TODO: any russian mirrors exists?
      # Replace the official cache with a mirror located in China
      #"https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"

      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  inputs = {
    # nixpkgs
    #master.url = "github:nixos/nixpkgs/master";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    #nixpkgs.follows = "master";

    #nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    #nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    #nix-index-database.url = "github:nix-community/nix-index-database";
    #nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # rust-overlay
    #rust-overlay.url = "github:oxalica/rust-overlay";

    # devenv
    #devenv.url = "github:cachix/devenv";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    #home-manager.url = "github:nix-community/home-manager";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zapret.url = "github:aca/zapret-flake/main";

    # gpt4all
    #gpt4all.url = "github:polygon/gpt4all-nix";
    #gpt4all.inputs.nixpkgs.follows = "nixpkgs";

    # anyrun
    #anyrun.url = "github:Kirottu/anyrun";
    #anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland
    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland.inputs.nixpkgs.follows = "nixpkgs";

    #hyprland-contrib.url = "github:hyprwm/contrib";
    #hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    # NUR
    #nur = {
    #  url = "github:nix-community/NUR";
    #};

    # stylix
    stylix.url = "github:danth/stylix";
    #stylix.url = "github:airradda/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    # Games
    # nix-gaming.url = "github:fufexan/nix-gaming";

    # lanzaboote
    #lanzaboote = {
    #  url = "github:nix-community/lanzaboote";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";

    # android
    # android-nixpkgs = {
    # url = "github:tadfisher/android-nixpkgs";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    stylix,
    #rust-overlay,
    #android-nixpkgs,
    #hyprland,
    #gpt4all,
    #nur,
    ...
  } @ inputs: let
    inherit (self) outputs; # The same as: outputs = self.outputs;
    systems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    formatter =
      forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};

    nixosModules = import ./modules/nixos;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      mixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            #stylix
            
            #impermanence
            
            #android-nixpkgs
            
            #hyprland
            
            ;
        };
        # > Our main nixos configuration file <
        modules = [
          #stylix.nixosModules.stylix

          ./modules/nixos/spoofdpi.nix

          ./modules/nixos/nh.nix

          ./hosts/mixos/configuration.nix

          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituers` in `flake.nix`
            nix.settings.trusted-users = ["@wheel" "aj01" "root"];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit
                inputs
                /*
                android-nixpkgs
                */
                
                ;
              hostName = "mixos";
            };
            home-manager.users.aj01 = import ./users/aj01/home.nix;
            home-manager.backupFileExtension = "backup";
          }

          #({pkgs, ...}: {
          #  nixpkgs.overlays = [rust-overlay.overlays.default];
          #  environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          #})
        ];
      };

      wixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            stylix
            #hyprland
            
            ;
        };
        # > Our main nixos configuration file <
        modules = [
          {
            /*
              environment.systemPackages = [
              //inputs.zapret.packages.x86_64-linux.default
            ];
            */
          }

          impermanence.nixosModules.impermanence

          stylix.nixosModules.stylix

          ./modules/nixos/nh.nix

          ./hosts/wixos/configuration.nix

          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituers` in `flake.nix`
            nix.settings.trusted-users = ["@wheel" "aj01" "root"];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              hostName = "wixos";
            };
            home-manager.users.aj01 = import ./users/aj01/home.nix;
            home-manager.backupFileExtension = "backup";
          }

          #({pkgs, ...}: {
          #  nixpkgs.overlays = [rust-overlay.overlays.default];
          #  environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          #})
        ];
      };

      # Virtualbox system
      vixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            ;
        };
        # > Our main nixos configuration file <
        modules = [
          ./modules/nixos/nh.nix
          ./hosts/vixos/configuration.nix

          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituers` in `flake.nix`
            nix.settings.trusted-users = ["@wheel" "aj01" "root"];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.aj01 = import ./users/aj01/home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      # Horizont server
      nxh = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            ;
        };
        # > Our main nixos configuration file <
        modules = [
          #stylix.nixosModules.stylix
          ./hosts/nxh/configuration.nix

          ./modules/nixos/nextcloud.nix

          {
            # given the users in this list the right to specify additional substituters via:
            #    1. `nixConfig.substituers` in `flake.nix`
            nix.settings.trusted-users = ["@wheel" "aj01" "root"];
          }
        ];
      };
    };
  };
}
