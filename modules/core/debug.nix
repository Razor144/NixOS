{ lib, config, pkgs, ... }:

{
  options.my.debug.enable = lib.mkEnableOption "a small system-wide debug toolkit";

  config = lib.mkIf config.my.debug.enable {
    environment.systemPackages = with pkgs; [
      btop
      dnsutils
      ethtool
      lsof
      pciutils
      strace
    ];
  };
}
