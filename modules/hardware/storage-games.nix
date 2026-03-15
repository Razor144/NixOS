{ lib, config, ... }:

let
  cfg = config.my.storage.games;
  mountPath = "/games";
  steamLibraryPath = "${mountPath}/steam";
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
    fileSystems.${mountPath} = {
      device = "/dev/disk/by-uuid/${cfg.uuid}";
      fsType = "ext4";
      options = [
        "defaults"
        "x-gvfs-show"
        "x-gvfs-name=Games"
      ];
    };

    systemd.tmpfiles.rules = [
      "d ${steamLibraryPath} 2775 chris chris -"
    ];
  };
}
