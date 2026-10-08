{
  lib,
  config,
  pkgs,
  ...
}:
let
  sec = config.ryeConfig.security;
  cfg = sec.ghidra;
  python = pkgs.python3.withPackages (ps: [ ps.pyghidra ]);
in
{
  config = lib.mkIf cfg.pyghidra.enable {
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "pyghidra-gui" ''
        export GHIDRA_INSTALL_DIR=${cfg.package}/lib/ghidra
        export JAVA_HOME=${pkgs.openjdk21.home}
        exec ${python}/bin/python -m pyghidra --gui "$@"
      '')
    ];
  };
}
