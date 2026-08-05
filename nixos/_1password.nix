{ lib, config, ... }:
let
  sec = config.myConfig.security;
  cfg = sec._1password;
in
{
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs._1password-gui = {
        enable = true;
        package = cfg.package;
        polkitPolicyOwners = sec.users;
      };
      warnings = lib.optional (sec.users == [ ]) ''
        myConfig.security._1password is enabled but myConfig.security.users is
        empty; the polkit helper will refuse every unlock request.
      '';
    })
    (lib.mkIf cfg.cli.enable { programs._1password.enable = true; })
  ];
}
