{ lib, config, pkgs, ... }:
let
  sec = config.ryeConfig.security;
  cfg = sec.wireshark;
in
{
  config = lib.mkIf (cfg.enable || cfg.tshark.enable) {
    programs.wireshark = {
      enable = true;
      package = if cfg.enable then cfg.package else pkgs.wireshark-cli;
    };
    users.users = lib.genAttrs sec.users (_: {
      extraGroups = [ "wireshark" ];
    });
  };
}
