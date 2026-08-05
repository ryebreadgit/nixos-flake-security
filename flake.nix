{
  description = "Security tooling: secrets, VPN, network and binary analysis";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    core.url = "github:ryebreadgit/nixos-flake-core";
  };

  outputs = { self, ... }: {
    nixosModules = {
      security = import ./nixos;
      default = self.nixosModules.security;
    };
    homeManagerModules = {
      security = import ./home;
      default = self.homeManagerModules.security;
    };
  };
}
