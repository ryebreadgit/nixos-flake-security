{ coreLib }:
{
  imports = [
    (import ./options.nix { inherit coreLib; })
    ./_1password.nix
    ./mullvad.nix
    ./wireshark.nix
    ./tcpdump.nix
  ];
}
