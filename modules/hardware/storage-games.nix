{ lib, config, ... }:

let
  cfg = config.my.storage.games;
in
{
  options.my.storage.games = {
    enable = lib.mkEnableOption "mounting a dedicated games SSD at /games";

    uuid = lib.mkOption {
      type = lib.types.str;
      example = "11111111-2222-3333-4444-555555555555";
      description = "UUID of the ext4 partition mounted at /games.";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/games" = {
      device = "/dev/disk/by-uuid/${cfg.uuid}";
      fsType = "ext4";
    };
  };
}
