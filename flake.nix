{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
      impermanence.url = "github:nix-community/impermanence";
};

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-minecraft,
      nixpkgs-unstable,
      impermanence,
      ...
    }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/configuration.nix
          impermanence.nixosModules.impermanence
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
