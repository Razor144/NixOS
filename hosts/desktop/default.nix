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

  my.profiles.desktop.enable = true;
  my.profiles.gaming.enable = true;
  my.debug.enable = true;
  my.hardware.rgb.enable = true;
  my.storage.games.enable = true;
  my.storage.games.label = "games-linux";
}
