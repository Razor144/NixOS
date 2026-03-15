{ lib, config, pkgs, ... }:

lib.mkIf config.my.profiles.desktop.enable {
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
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
