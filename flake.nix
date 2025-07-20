{
  description = "An example using declarative-jellyfin flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    declarative-jellyfin = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Sveske-Juice";
      repo = "declarative-jellyfin";
      type = "github";
    };

    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Mic92";
      repo = "sops-nix";
      type = "github";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/homeserver/configuration.nix
          inputs.declarative-jellyfin.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
      };
      nixosConfigurations."hms-test" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/hms-test/configuration.nix
          inputs.declarative-jellyfin.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
}
