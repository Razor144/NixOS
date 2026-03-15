{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nodejs_20
    nodePackages.npm
    parted
  ];
}
