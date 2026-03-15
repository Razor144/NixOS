{ lib, config, pkgs, ... }:

let
  cfg = config.my.profiles.gaming;
in
{
  options.my.profiles.gaming.enable = lib.mkEnableOption "gaming profile";

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      lutris
      heroic
      mangohud
      gamescope
    ];
  };
}
