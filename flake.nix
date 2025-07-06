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

  outputs = { nixpkgs, self, ... }@inputs:
    let
      system = "x86_64-linux";
      version = "25.05";
      hostname = "homeserver";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        ${hostname} = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit hostname;
            inherit inputs;
          };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
