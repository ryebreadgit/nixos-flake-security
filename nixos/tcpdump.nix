{ lib, config, pkgs, ... }:
let
  sec = config.ryeConfig.security;
  cfg = sec.tcpdump;
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [
    { environment.systemPackages = lib.mkIf (!cfg.wrapper) [ pkgs.tcpdump ]; }

    (lib.mkIf cfg.wrapper {
      users.groups.pcap = { };
      users.users = lib.genAttrs sec.users (_: { extraGroups = [ "pcap" ]; });
      security.wrappers.tcpdump = {
        owner = "root";
        group = "pcap";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin=ep";
        source = lib.getExe pkgs.tcpdump;
      };
    })
  ]);
}
