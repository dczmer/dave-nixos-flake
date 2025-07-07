{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/baseSystem
    ./hardware-configuration.nix
  ];

  # for nixos-rebuild build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      restrictNetwork = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = lib.mkForce {
    root = {
      # XXX the value of the un-opened partition, not the apped drive
      device = "/dev/disk/by-uuid/92925364-7d45-4d9f-9546-c3d2ff3aa13e";
      preLVM = true;
      allowDiscards = true;
    };
  };
  fileSystems."/boot".neededForBoot = true;

  # enable virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  baseSystem.users.dave.extraGroups = [ "libvirtd" ];

  networking.hostName = "marvin2"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hosts = {
    "127.0.0.1" = [ "marvin2" ];
    "192.168.1.69" = [ "guinness" ];
    "192.168.1.135" = [ "lucky" ];
  };
  networking.extraHosts = ''
    127.0.0.1			marvin2
    192.168.1.69	    guinness
    192.168.1.135       lucky
  '';
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ 1900 ];

  baseSystem.zsh = true;
  baseSystem.gnome.enable = true;
  baseSystem.printing.enable = false;
  baseSystem.chromium.enable = true;
  baseSystem.docker.enable = true;
  baseSystem.i3.enable = true;
  baseSystem.laptop.enable = true;

  programs.steam.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    dosfstools
    wol
    vulkan-tools
    #winetricks
    #steamtinkerlaunch
    glxinfo
    gnome-tweaks
    gnomeExtensions.appindicator
    sshfs-fuse
    borgbackup
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
