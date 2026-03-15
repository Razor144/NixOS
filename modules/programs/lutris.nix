{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.my.profiles.gaming.enable {
    environment.systemPackages = with pkgs; [
      lutris
    ];
  };
}
