{ lib, config, ... }:
let
  cfg = config.myConfig.security.mullvad;
  mullvad = lib.getExe' cfg.package "mullvad";
in
{
  config = lib.mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = cfg.package;
    };

    systemd.services.mullvad-settings = lib.mkIf (cfg.autoConnect || cfg.lockdown) {
      description = "Apply declarative Mullvad daemon settings";
      after = [ "mullvad-daemon.service" ];
      requires = [ "mullvad-daemon.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        for _ in $(seq 1 15); do
          ${mullvad} status >/dev/null 2>&1 && break
          sleep 1
        done
        ${mullvad} auto-connect set ${if cfg.autoConnect then "on" else "off"}
        ${mullvad} lockdown-mode set ${if cfg.lockdown then "on" else "off"}
      '';
    };
  };
}
