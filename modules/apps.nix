{ lib, config, pkgs, ... }:

lib.mkIf config.my.profiles.desktop.enable {
  environment.systemPackages = with pkgs; [
    discord
    vlc
    unzip
    p7zip
    file
    htop
    fastfetch
    spotify
    git
    bitwarden-desktop
  ];
}
