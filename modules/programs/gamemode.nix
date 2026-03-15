{ lib, config, ... }:

{
  config = lib.mkIf config.my.profiles.gaming.enable {
    programs.gamemode.enable = true;
  };
}
