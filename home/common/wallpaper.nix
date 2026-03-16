{ pkgs, ... }:

let
  wallpaper = ../../assets/wallpapers/Hintergrundbild3440.png;
  wallpaperTarget = ".local/share/wallpapers/Hintergrundbild3440.png";
  setWallpaper = pkgs.writeShellScriptBin "set-desktop-wallpaper" ''
    wallpaper="$HOME/${wallpaperTarget}"

    if [ ! -f "$wallpaper" ]; then
      exit 0
    fi

    if command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
      plasma-apply-wallpaperimage "$wallpaper" >/dev/null 2>&1 || true
    fi
  '';
in
{
  home.file."${wallpaperTarget}".source = wallpaper;

  home.packages = [ setWallpaper ];

  xdg.configFile."autostart/set-desktop-wallpaper.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Set Desktop Wallpaper
    Exec=${setWallpaper}/bin/set-desktop-wallpaper
    OnlyShowIn=KDE;
    X-KDE-Autostart-phase=1
    NoDisplay=true
  '';
}
