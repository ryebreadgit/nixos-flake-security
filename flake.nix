{
  description = "Security tooling: secrets, VPN, network and binary analysis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    core = {
      url = "github:ryebreadgit/nixos-flake-core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, core }:
    {
      nixosModules = rec {
        security = import ./nixos { coreLib = core.lib; };
        default = security;
      };

      homeManagerModules = rec {
        security = import ./home { coreLib = core.lib; };
        default = security;
      };
    };
}
