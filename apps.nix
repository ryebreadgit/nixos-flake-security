# nixos-flake-security/apps.nix
{
  ghidra = {
    gui = true;
    description = "Ghidra reverse-engineering suite.";
  };
  mitmproxy = {
    description = "mitmproxy interactive HTTPS proxy.";
  };
}
