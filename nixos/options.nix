{ coreLib }:
{ lib, config, pkgs, ... }:
let
  cfg = config.myConfig.security;
  apps = import ../apps.nix;
  common = {
    category = "security";
    categoryCfg = cfg;
    guiCfg = config.myConfig.gui;
  };
  mkApp = coreLib.mkApp common;
  simple = coreLib.mkSimpleOptions (common // { inherit pkgs apps; });
in
{
  options.myConfig.security = simple // {
    enable = lib.mkEnableOption "security tooling" // { default = true; };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = config.myConfig.users;
      defaultText = lib.literalExpression "config.myConfig.users";
      description = "Accounts granted capture and unlock rights.";
    };

    _1password = {
      enable = mkApp { description = "1Password desktop client."; needsGui = true; };
      package = lib.mkPackageOption pkgs "_1password-gui" { };
      cli.enable = mkApp { description = "1Password CLI (`op`)."; };
      sshAgent.enable = mkApp {
        description = "Route SSH authentication through the 1Password agent.";
      };
    };

    mullvad = {
      enable = mkApp { description = "Mullvad VPN client and daemon."; needsGui = true; };
      package = lib.mkPackageOption pkgs "mullvad-vpn" { };
      autoConnect = lib.mkOption { type = lib.types.bool; default = false; };
      lockdown = lib.mkOption { type = lib.types.bool; default = false; };
    };

    wireshark = {
      enable = mkApp { description = "Wireshark packet analyser (GUI)."; needsGui = true; };
      package = lib.mkPackageOption pkgs "wireshark" { };
      tshark.enable = mkApp { description = "tshark, the headless packet analyser."; };
    };

    tcpdump = {
      enable = mkApp { description = "tcpdump packet capture."; };
      wrapper = lib.mkOption { type = lib.types.bool; default = true; };
    };
  };
}
