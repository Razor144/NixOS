{ lib, pkgs, ... }:

let
  wallpaper = ../../assets/wallpapers/Hintergrundbild3440.png;
  wallpaperTarget = ".local/share/wallpapers/Hintergrundbild3440.png";
in
{
  home.file."${wallpaperTarget}".source = wallpaper;

  home.activation.setPlasmaWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    configFile="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
    wallpaperPath="$HOME/${wallpaperTarget}"
    wallpaperUrl="file://$wallpaperPath"

    if [ ! -f "$configFile" ] || [ ! -f "$wallpaperPath" ]; then
      exit 0
    fi

    desktopContainments="$(${pkgs.gawk}/bin/awk '
      /^\[Containments\]\[[0-9]+\]$/ {
        currentId = $0
        sub(/^\[Containments\]\[/, "", currentId)
        sub(/\]$/, "", currentId)
        inContainment = 1
        next
      }

      /^\[/ {
        inContainment = 0
      }

      inContainment && $0 == "plugin=org.kde.plasma.folder" {
        print currentId
      }
    ' "$configFile" | ${pkgs.coreutils}/bin/sort -n | ${pkgs.coreutils}/bin/uniq)"

    if [ -z "$desktopContainments" ]; then
      exit 0
    fi

    tmpFile="$(${pkgs.coreutils}/bin/mktemp)"
    trap '${pkgs.coreutils}/bin/rm -f "$tmpFile"' EXIT

    ${pkgs.gawk}/bin/awk \
      -v wallpaper="$wallpaperUrl" \
      -v ids="$desktopContainments" \
      '
        BEGIN {
          split(ids, idList, "\n")
          for (i in idList) {
            if (idList[i] != "") {
              wanted[idList[i]] = 1
            }
          }
        }

        function flushSection(    id) {
          if (inWallpaperSection && currentWallpaperId != "" && !imageWritten[currentWallpaperId]) {
            print "Image=" wallpaper
            imageWritten[currentWallpaperId] = 1
          }

          inWallpaperSection = 0
          currentWallpaperId = ""
        }

        /^\[Containments\]\[[0-9]+\]\[Wallpaper\]\[org\.kde\.image\]\[General\]$/ {
          flushSection()
          currentWallpaperId = $0
          sub(/^\[Containments\]\[/, "", currentWallpaperId)
          sub(/\]\[Wallpaper\]\[org\.kde\.image\]\[General\]$/, "", currentWallpaperId)
          inWallpaperSection = wanted[currentWallpaperId]
          seen[currentWallpaperId] = wanted[currentWallpaperId]
          print
          next
        }

        /^\[/ {
          flushSection()
          print
          next
        }

        inWallpaperSection && /^Image=/ {
          print "Image=" wallpaper
          imageWritten[currentWallpaperId] = 1
          next
        }

        {
          print
        }

        END {
          flushSection()

          for (id in wanted) {
            if (!seen[id]) {
              print ""
              print "[Containments][" id "][Wallpaper][org.kde.image][General]"
              print "Image=" wallpaper
            }
          }
        }
      ' "$configFile" > "$tmpFile"

    ${pkgs.coreutils}/bin/cp "$tmpFile" "$configFile"
  '';
}
