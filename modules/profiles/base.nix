{ ... }:
{
  imports = [
    ../core/sudo.nix
    ../core/locale.nix
    ../core/networking.nix
    ../core/users.nix
    ../core/nix-settings.nix
    ../core/debug.nix
    ../hardware/default.nix
    ../storage.nix
  ];
}
