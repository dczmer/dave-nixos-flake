#
# Description:
#
# Primary desktop and gaming PC.
# Has lots of M2 and SSD drives, 128GB DDR5, 8-core/16-thread AMD Ryzen 7 processor, RX 6800 XT.
#
{ pkgs, ... }:
{
  imports = [
    # base settings for all of my machines
    ../modules/baseSystem

    # include results of the hardware scan
    ./hardware-configuration.nix
  ];

  # for nixos-rebuild build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4098;
      cores = 4;
      restrictNetwork = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/steam1".neededForBoot = true;
  fileSystems."/steam2".neededForBoot = true;

  # enable virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  networking.hostName = "lucky";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [ "lucky" ];
    "192.168.1.69" = [ "guinness" ];
  };
  networking.extraHosts = ''
    127.0.0.1     lucky
    192.168.1.69  guinness
    192.168.1.69  guinneweb
  '';
  networking.firewall.allowedTCPPorts = [ 6969 ];
  networking.firewall.allowedUDPPorts = [ 1900 ];
  networking.interfaces.eno1 = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "192.168.1.135";
          prefixLength = 24;
        }
      ];
    };
  };
  networking.defaultGateway = "192.168.1.1";

  baseSystem.zsh = true;
  baseSystem.users.dave = {
    extraGroups = [
      "networkmanager"
      "libvirtd"
    ];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGdv9tCrmZCeuEPKYlgL7exHsq2zxtYiYZYtZ0ug/r5 dczmer@gmail.com"
    ];
  };
  baseSystem.docker.enable = true;
  baseSystem.gnome.enable = true;
  baseSystem.ssh.enable = true;
  baseSystem.printing.enable = true;
  baseSystem.printing.allowDiscovery = false;
  baseSystem.chromium.enable = true;
  baseSystem.i3.enable = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  programs.steam.enable = true;

  # only system-level packages or things that will be needed by root
  environment.systemPackages = with pkgs; [
    borgbackup
    cabextract
    clamav
    file
    screen
    parted
    vulkan-tools
    wineWowPackages.stable
    wineWowPackages.waylandFull
    winetricks
    glxinfo
    wol
    steamtinkerlaunch
    gnome-tweaks
    gnomeExtensions.appindicator
    sshfs-fuse
    xorg.xrdb
  ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
