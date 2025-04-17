{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
      impermanence.url = "github:nix-community/impermanence";
      sops-nix.url = "github:Mic92/sops-nix";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
            home-manager.users.calle = import ./skit.nix;
           # home-manager.users.calle = import ./home.nix {
           #   lib = nixpkgs.lib;
           #   config = {};
           #   inherit pkgs;
           # };
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
    };
  };
}
