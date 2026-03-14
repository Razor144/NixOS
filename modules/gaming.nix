{ config, pkgs, ... }:

{
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    lutris
    heroic
    protonup
    gamescope
    gamemomde
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
