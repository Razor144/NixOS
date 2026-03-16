{ lib, config, pkgs, ... }:

let
  blackSddmTheme = pkgs.runCommandLocal "sddm-theme-breeze-black" { } ''
    themeDir="$out/share/sddm/themes/breeze-black"
    mkdir -p "$themeDir"
    cp -r ${pkgs.kdePackages.plasma-desktop}/share/sddm/themes/breeze/. "$themeDir/"

    printf '%s\n' \
      '[General]' \
      'type=color' \
      'color=#000000' \
      'background=' \
      'showlogo=hidden' \
      > "$themeDir/theme.conf.user"
  '';
in
lib.mkIf config.my.profiles.desktop.enable {
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "de";
    xkb.variant = "";
  };

  console.keyMap = "de";

  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" ];
    plymouth = {
      enable = true;
      theme = "spinner";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    theme = "breeze-black";
  };
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig."90-astro-a50" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.usb-Astro_Gaming_Astro_A50-00";
              }
            ];
            actions = {
              update-props = {
                "api.alsa.use-acp" = false;
                "api.alsa.split-enable" = true;
              };
            };
          }
        ];
      };
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
  ];

  programs.nano.enable = true;
  environment.variables.EDITOR = "nano";

  environment.systemPackages = with pkgs; [
    nano
    git
    wget
    curl
    fastfetch
    alsa-utils
    pavucontrol
    pipewire
    usbutils
    wireplumber
    blackSddmTheme
  ];
}
