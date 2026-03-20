{ pkgs, ... }:

let
  kscreenResumeFix = pkgs.writeShellApplication {
    name = "kscreen-resume-fix";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      jq
      kdePackages.libkscreen
    ];
    text = ''
      set -eu

      get_dp2_size() {
        kscreen-doctor -j \
          | jq -r '.outputs[]
            | select(.name == "DP-2" and .connected and .enabled)
            | "\(.size.width)x\(.size.height)"' \
          | head -n1
      }

      get_dp2_mode_id() {
        kscreen-doctor -j \
          | jq -r '.outputs[]
            | select(.name == "DP-2")
            | .modes[]
            | select(.size.width == 2560 and .size.height == 1440 and .refreshRate > 143 and .refreshRate < 145)
            | .id' \
          | head -n1
      }

      # DP-2 occasionally wakes up without valid EDID and falls back to 640x480 only.
      # In that case we inject the known-good 2560x1440@144 mode and re-apply it.
      sleep 8

      for _attempt in 1 2 3 4 5; do
        size="$(get_dp2_size || true)"

        if [ -z "$size" ] || [ "$size" = "2560x1440" ]; then
          exit 0
        fi

        if [ "$size" = "640x480" ]; then
          kscreen-doctor output.DP-2.addCustomMode.2560.1440.144000.reduced >/dev/null 2>&1 || true
          mode_id="$(get_dp2_mode_id || true)"

          if [ -n "$mode_id" ]; then
            kscreen-doctor \
              output.DP-2.enable \
              output.DP-2.mode."$mode_id" \
              output.DP-2.position.2560,0 \
              output.DP-2.scale.1 \
              >/dev/null 2>&1 || true
          fi
        fi

        sleep 2
      done
    '';
  };
in
{
  systemd.user.services.kscreen-resume-fix = {
    Unit = {
      Description = "Restore the right monitor mode after resume if DP-2 falls back to 640x480";
      Before = [
        "sleep.target"
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "${kscreenResumeFix}/bin/kscreen-resume-fix";
    };

    Install = {
      WantedBy = [
        "suspend.target"
        "hibernate.target"
        "hybrid-sleep.target"
        "suspend-then-hibernate.target"
      ];
    };
  };
}
