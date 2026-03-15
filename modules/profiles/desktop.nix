{ lib, ... }:

{
  options.my.profiles.desktop.enable = lib.mkEnableOption "desktop profile";

  imports = [
    ../desktop.nix
    ../apps.nix
    ../programs/cli.nix
  ];
}
