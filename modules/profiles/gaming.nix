{ lib, ... }:

{
  options.my.profiles.gaming.enable = lib.mkEnableOption "gaming profile";

  imports = [
    ../gaming.nix
  ];
}
