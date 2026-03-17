{ lib, config, ... }:

{
  config = lib.mkIf config.my.profiles.gaming.enable {
    programs.steam = {
      enable = true;
      protontricks.enable = true;
    };
  };
}
