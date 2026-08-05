{ coreLib }:
{ lib, osConfig ? null, ... }:
let
  sec =
    if osConfig == null then
      throw ''
        nixos-flake-security: this module needs `osConfig`, so home-manager
        must be imported as a NixOS module. Standalone `home-manager switch`
        is not supported.
      ''
    else
      osConfig.ryeConfig.security;
in
{
  config = lib.mkMerge [
    { home.packages = coreLib.mkSimplePackages { categoryCfg = sec; apps = import ../apps.nix; }; }

    (lib.mkIf sec._1password.sshAgent.enable {
      programs.ssh = {
        enable = true;
        matchBlocks."*".extraOptions.IdentityAgent = "~/.1password/agent.sock";
      };
    })
  ];
}
