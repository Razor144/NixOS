{
  networking.networkmanager.dns = "systemd-resolved";

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "opportunistic";
      FallbackDNS = [
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
        "149.112.112.112"
      ];
    };
  };
}
