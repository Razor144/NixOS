# NixOS

Flake-basiertes NixOS-Repository fuer ein Desktop-System mit KDE Plasma, Gaming-Setup und integriertem Home Manager.

## Aktueller Stand

- Desktop-Profil mit KDE Plasma 6, SDDM und PipeWire
- Desktop-Profil enthaelt die alltaeglichen GUI-Basisprogramme systemweit, inklusive Firefox, Discord und Telegram Desktop
- Gaming-Profil mit Steam, Gamescope, MangoHud, GameMode, Heroic und Lutris
- `programs.steam.protontricks.enable = true` fuer kleine Proton-/Steam-Fixes
- Dedizierte Games-SSD unter `/games`
- Optionales Debug-Toolkit ueber `my.debug.enable`
- NetworkManager nutzt `systemd-resolved`; DHCP-DNS bleibt primaer, oeffentliche Resolver sind nur Fallback
- Automatische `nix.gc` laeuft woechentlich mit `--delete-older-than 14d`
- Automatische `nix.optimise` laeuft ebenfalls woechentlich

## Verantwortung im aktuellen Setup

- Git laeuft aktiv ueber Home Manager (`programs.git.enable = true`)
- Firefox ist aktuell bewusst systemweit ueber das Desktop-Profil aktiviert
- Vorbereitete, derzeit ungenutzte Moduldateien bleiben als Strukturreserve erhalten

## Update-Strategie

Der aktuelle `nixpkgs`-Lock wird bewusst auf einem funktionierenden Stand gehalten. Ein neuerer Lock hat den Build zuletzt ueber `electron` und davon abhaengige Pakete wie `bitwarden-desktop` und `heroic` gebrochen.

Empfohlenes Vorgehen fuer kuenftige Updates:

```bash
nix flake lock --update-input nixpkgs
nix build .#nixosConfigurations.desktop.config.system.build.toplevel
```

Erst wenn der Build erfolgreich ist, sollte der neue Lock uebernommen werden.
