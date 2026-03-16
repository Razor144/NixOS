{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./thunderbird.nix
  ];

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    bitwarden-desktop
    spotify
  ];

  programs.git.enable = true;
}
