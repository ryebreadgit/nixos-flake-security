{ lib, config, ... }:
let
  sec = config.ryeConfig.security;
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
        ryeConfig.security._1password is enabled but ryeConfig.security.users is
        empty; the polkit helper will refuse every unlock request.
      '';
    })
    (lib.mkIf cfg.cli.enable { programs._1password.enable = true; })
  ];
}
