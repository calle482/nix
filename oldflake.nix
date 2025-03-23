{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
      netns-exec.flake = false;
};

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-minecraft,
      ...
    }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules =
        [ ./configuration.nix
          ./modules/media.nix
          ./modules/minecraft.nix
          nix-minecraft.nixosModules.minecraft-servers
          {
            nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
          }
        ];
    };
  };
};

}
