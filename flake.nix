{
  description = "AJ nix config";

  inputs = {
    # nixpkgs
    nixpkgs.follows = "master";

    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    master.url = "github:nixos/nixpkgs/master";
    #stable.url = "github:nixos/nixpkgs/release-23.05";
    #unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # anyrun
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    # hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-contrib.url = "github:hyprwm/contrib";
    hyprland-contrib.inputs.nixpkgs.follows = "nixpkgs";

    # stylix
    stylix.url = "github:danth/stylix";
    #stylix.url = "github:airradda/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    # Games
    nix-gaming.url = "github:fufexan/nix-gaming";

    # lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    impermanence,
    stylix,
    hyprland,
    ...
  } @ inputs: let
    inherit (self) outputs;
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
            stylix
            hyprland
            ;
        };
        # > Our main nixos configuration file <
        modules = [
          #stylix.nixosModules.stylix
          ./hosts/mixos/configuration.nix

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
          ./hosts/vixos/configuration.nix
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
    };
  };
}
