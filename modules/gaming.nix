{ lib, config, pkgs, ... }:

{
  imports = [
    ./programs/steam.nix
    ./programs/gamemode.nix
    ./programs/mangohud.nix
  ];

  config = lib.mkIf config.my.profiles.gaming.enable {
    environment.systemPackages = with pkgs; [
      heroic
      lutris
      gamescope
    ];
  };
}
