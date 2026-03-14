{ config, pkgs, lib, ... }:

let
  mainUser = "user";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/storage.nix
  ];

  networking.hostName = "lNixOS-desktop";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  console.keyMap = "de";

  users.users.${mainUser} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
