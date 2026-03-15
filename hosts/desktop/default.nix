{ ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/profiles/base.nix
      ../../modules/profiles/desktop.nix
      ../../modules/profiles/gaming.nix
    ]
    ++ (if builtins.pathExists ./local.nix then [ ./local.nix ] else [ ]);

  networking.hostName = "nixos";
}
