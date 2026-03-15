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
  my.storage.games.enable = true;
  my.storage.games.uuid = "5606294a-c7b3-458b-ae67-0f6fd05b4ac0";
}
