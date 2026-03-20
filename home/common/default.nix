{ pkgs, ... }:

{
  imports = [
    ./display-resume.nix
    ./shell.nix
    ./wallpaper.nix
    ./thunderbird.nix
  ];

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    numlockx
    spotify
  ];

  xdg.configFile."autostart/numlockx.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Enable Numlock
    Exec=${pkgs.numlockx}/bin/numlockx on
    OnlyShowIn=KDE;
    X-KDE-Autostart-phase=1
    NoDisplay=true
  '';

  programs.git.enable = true;
}
