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
    {
      self,
      nixpkgs,
      core,
    }:
    {
      nixosModules = rec {
        security = import ./nixos { coreLib = core.lib; };
        default = security;
      };

      homeManagerModules = rec {
        security = import ./home { coreLib = core.lib; };
        default = security;
      };

      # Every module and app enabled, so any broken package fails the build.
      checks.x86_64-linux.default =
        (nixpkgs.lib.nixosSystem {
          modules = [
            core.nixosModules.default
            self.nixosModules.default
            ({ config, ... }: {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.config.allowUnfree = true;
              boot.loader.grub.enable = false;
              fileSystems."/".fsType = "tmpfs";
              system.stateVersion = config.system.nixos.release;
              ryeConfig.users = [ "ci" ];
              users.users.ci.isNormalUser = true;
              environment.systemPackages = core.lib.mkSimplePackages {
                categoryCfg = config.ryeConfig.security;
                apps = import ./apps.nix;
              };
            })
          ];
        }).config.system.build.toplevel;
    };
}
