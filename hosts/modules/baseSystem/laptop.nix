{
  lib,
  config,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.baseSystem.laptop;
in
{
  options.baseSystem.laptop = {
    enable = mkEnableOption "Common laptop stuff";
  };

  config = mkIf cfg.enable {
    powerManagement.enable = true;
    networking.networkmanager.wifi.powersave = true;
    services.logind.lidSwitch = "suspend-then-hibernate";
    services.logind.lidSwitchDocked = "lock";
    environment.systemPackages = with pkgs; [
      acpi
      brightnessctl
      powertop
      iw
    ];
    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        leftHanded = false;
        scrollMethod = "twofinger";
        naturalScrolling = true;
        middleEmulation = true;
        tappingDragLock = true;
        horizontalScrolling = true;
        disableWhileTyping = true;
        clickMethod = "buttonareas";
      };
    };
  };
}
