{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
};

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-minecraft,
      ...
    }:

  {

    overlays = [
      (import ./overlays/caddy.nix inputs)
    ];

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos/configuration.nix
          nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
      };
    };
  };
}
