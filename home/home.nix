{ pkgs, ... }:

{
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    firefox
    bitwarden-desktop
    spotify
  ];

  programs.git.enable = true;
}
