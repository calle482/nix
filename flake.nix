{

  description = "My first flake";

  inputs = {
      nixpkgs.url= "github:NixOS/nixpkgs/nixos-24.11";
      nix-minecraft.url = "github:Infinidoge/nix-minecraft";
};

  outputs = { self, nixpkgs, ... }:
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
        ];
    };
  };
};

}
