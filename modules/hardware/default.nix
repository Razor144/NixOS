{ lib, config, pkgs, ... }:

let
  cfg = config.my.hardware.rgb;
  iceBlue = "99e6ff";
in
{
  options.my.hardware.rgb = {
    enable = lib.mkEnableOption "RGB and AIO hardware control";

    motherboard = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "amd" "intel" ]);
      default =
        if config.hardware.cpu.intel.updateMicrocode then
          "intel"
        else if config.hardware.cpu.amd.updateMicrocode then
          "amd"
        else
          null;
      defaultText = lib.literalMD ''
        if config.hardware.cpu.intel.updateMicrocode then "intel"
        else if config.hardware.cpu.amd.updateMicrocode then "amd"
        else null
      '';
      description = "Mainboard family for optional SMBus/I2C access used by some RGB devices.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openrgb
      liquidctl
    ];

    services.udev.packages = with pkgs; [
      openrgb
      liquidctl
    ];

    boot.kernelModules =
      [ "i2c-dev" ]
      ++ lib.optionals (cfg.motherboard == "amd") [ "i2c-piix4" ]
      ++ lib.optionals (cfg.motherboard == "intel") [ "i2c-i801" ];

    systemd.services.rgb-and-aio-setup = {
      description = "Apply RGB color and NZXT Kraken cooling profile";
      wantedBy = [ "multi-user.target" ];
      wants = [ "systemd-udev-settle.service" ];
      after = [ "systemd-udev-settle.service" ];

      serviceConfig.Type = "oneshot";

      script = ''
        ${pkgs.liquidctl}/bin/liquidctl --match kraken initialize
        ${pkgs.liquidctl}/bin/liquidctl --match kraken set fan speed 20 25 30 35 34 45 38 60 42 80 46 100
        ${pkgs.liquidctl}/bin/liquidctl --match kraken set pump speed 20 60 30 70 34 80 38 90 42 100
        ${pkgs.liquidctl}/bin/liquidctl --match kraken set sync color fixed ${iceBlue}
        HOME=/tmp ${pkgs.openrgb}/bin/openrgb --noautoconnect --config /tmp --device 0 --mode Static --color ${iceBlue} --device 1 --mode Static --color ${iceBlue} --device 2 --mode Static --color ${iceBlue} --device 3 --mode Static --color ${iceBlue} --device 4 --zone 0 --size 40 --mode Static --color ${iceBlue} --device 4 --zone 1 --size 40 --mode Static --color ${iceBlue} --device 4 --zone 2 --size 40 --mode Static --color ${iceBlue} --device 4 --zone 3 --size 40 --mode Static --color ${iceBlue}
      '';
    };
  };
}
