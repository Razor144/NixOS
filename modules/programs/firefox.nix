{ lib, config, ... }:

lib.mkIf config.my.profiles.desktop.enable {
  programs.firefox = {
    enable = true;
    policies = {
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      NoDefaultBookmarks = true;
    };
  };
}
