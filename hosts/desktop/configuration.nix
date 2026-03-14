{ config, pkgs, lib, ... }:

let
  mainUser = "user";
in
{
  imports = [
    ./local.nix
    ./hardware-configuration.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/storage.nix
  ];

  networking.hostName = "lNixOS-desktop";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  console.keyMap = "de";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.${mainUser} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
