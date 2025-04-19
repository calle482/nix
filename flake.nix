{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
      impermanence.url = "github:nix-community/impermanence";
      sops-nix.url = "github:Mic92/sops-nix";
      home-manager.url = "github:nix-community/home-manager/release-24.11";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      home-manager-unstable.url= "github:nix-community/home-manager";
      home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
      hyprland.url = "github:hyprwm/Hyprland";
      plasma-manager = {
        url = "github:nix-community/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
        inputs.home-manager.follows = "home-manager-unstable";
      };
};

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-minecraft,
      nixpkgs-unstable,
      impermanence,
      sops-nix,
      home-manager,
      home-manager-unstable,
      plasma-manager,
      hyprland,
      ...
    }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixlab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixlab/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
            home-manager.users.calle = {
              imports = [
                ./home/nixlab.nix
                sops-nix.homeManagerModules.sops
              ];
            };
          }
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
        specialArgs = {
          inherit pkgs-unstable;
        };
      };



      nix = nixpkgs-unstable.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nix/configuration.nix
          home-manager-unstable.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
              plasma-manager.homeManagerModules.plasma-manager
            ];
            home-manager.users.calle = {
              imports = [
                ./home/nix.nix
                sops-nix.homeManagerModules.sops
              ];
            };
          }
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}
