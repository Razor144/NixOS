{ pkgs, ... }:
{
  users.groups.chris = {};

  users.users.chris = {
    isNormalUser = true;
    group = "chris";
    description = "Chris";
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ ];
  };
}
