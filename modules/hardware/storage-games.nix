{ lib, config, ... }:

let
  cfg = config.my.storage.games;
  mountPath = "/games";
  steamLibraryPath = "${mountPath}/steam";
in
{
  options.my.storage.games = {
    enable = lib.mkEnableOption "mounting a dedicated games SSD at /games";

    label = lib.mkOption {
      type = lib.types.str;
      example = "games-linux";
      description = "Filesystem label of the ext4 partition mounted at /games.";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems.${mountPath} = {
      device = "/dev/disk/by-label/${cfg.label}";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
        "x-systemd.device-timeout=1s"
        "x-gvfs-show"
        "x-gvfs-name=Games"
      ];
    };

    systemd.tmpfiles.rules = [
      "z ${mountPath} 2775 chris chris -"
      "d ${steamLibraryPath} 2775 chris chris -"
    ];
  };
}
