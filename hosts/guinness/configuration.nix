# Description:
#
# Low-power file server that uses WoL and autosuspend daemon to go to sleep
# when not needed.
#
# I configure the bios to wake on RTC at 3:58AM and schedule 'overnight'
# jobs to run at 4:00AM.
#
# The autosuspend daemon takes 20 min before putting it back to sleep, so
# this usually gives enough time to finish everything.
#
# The system will not suspend if:
#   - there is an active session on tty1 (local login)
#   - there is an active ssh connection
#   - there is an active minidlna client connected
#
# There are some unfinished/improvements to be implemented:
#   - don't sleep when the schedule jobs (clam, nix, etc.) are running.
#     this should prevent suspend from starting before the overnight jobs
#     have completed.
#   - don't sleep while my cellphone is connected to wifi (while I'm at home).
#
{ config, pkgs, ... }:
{
  imports = [
    # base settings for all of my machines
    ../modules/baseSystem

    ./hardware-configuration.nix
  ];

  # for nixos-rebuild build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.swraid.enable = true;

  services.xserver.enable = false;
  hardware.pulseaudio.enable = false;

  users.groups.borg = {
    gid = 1001;
  };
  users.groups.mail = {
    gid = 1002;
  };
  users.groups.git = {
    gid = 1003;
  };

  users.users.git = {
    isNormalUser = true;
    group = "git";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGdv9tCrmZCeuEPKYlgL7exHsq2zxtYiYZYtZ0ug/r5 dczmer@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYJp/TzZf/9qQWoWMi05q5Mp1Ga8RNcjpl9sTWv5F46 dave@lucky"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZ4IiH8c+JT5NPZnvR3MLg5bQ6xE39DHSLp4wTDoISI dave@marvin2"
    ];
  };

  environment.shellAliases = {
    scrub-raid = "echo check > /sys/block/md127/md/sync_action";
    scrub-raid-status = "watch cat /proc/mdstat";
    scrub-raid-stop = "echo idle > /sys/block/md127/md/sync_action";
    scrub-raid-bad-blocks = "cat /sys/block/md127/md/mismatch_cnt";
  };

  baseSystem.zsh = false;
  baseSystem.users.dave = {
    extraGroups = [ "borg" ];
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGdv9tCrmZCeuEPKYlgL7exHsq2zxtYiYZYtZ0ug/r5 dczmer@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYJp/TzZf/9qQWoWMi05q5Mp1Ga8RNcjpl9sTWv5F46 dave@lucky"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGZ4IiH8c+JT5NPZnvR3MLg5bQ6xE39DHSLp4wTDoISI dave@marvin2"
    ];
  };
  baseSystem.docker.enable = true;
  baseSystem.ssh.enable = true;
  baseSystem.printing.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpid
    autosuspend
    borgbackup
    #clamav
    ethtool
    mailutils
    mdadm
    minidlna
    screen
    parted
    openssl
    htop
  ];

  # 6969 = ssh
  # 8200 = minidlna
  networking.firewall.allowedTCPPorts = [
    6969
    8200
  ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.hostName = "guinness";
  networking.interfaces.enp37s0 = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "192.168.1.69";
          prefixLength = 24;
        }
      ];
    };
    wakeOnLan.enable = true;
  };
  networking.hosts = {
    "127.0.0.1" = [ "guinness" ];
    "192.168.1.135" = [ "lucky" ];
  };
  networking.extraHosts = ''
    127.0.0.1     guinness
    127.0.0.1     guinneweb
    192.168.1.135 lucky
  '';
  networking.defaultGateway = "192.168.1.1";

  nix.gc.automatic = true;
  nix.gc.dates = "04:00";

  #services.clamav = {
  #  daemon.enable = true;
  #  updater.enable = true;
  #  updater.interval = "04:00";
  #};

  services.acpid.enable = true;
  services.autosuspend.enable = true;
  services.autosuspend.settings = {
    enable = true;
    interval = 30;
    idle_time = 1200;
  };
  services.autosuspend.checks = {
    ActiveConnection = {
      ports = "6969,8200";
    };
    # if user logged in locally
    Users = {
      name = "dave";
      terminal = "tty1";
    };
    # ping phone over wifi
    #Ping = { hosts = [ "192.168.1.116" ]; };
  };
  #services.autosuspend.wakeups = {
  #  # TODO: this prevents it from ever going to sleep for some reason
  #  SystemdTime = {
  #    match = "(nixos-upgrade|clamav-freshclam)";
  #  };
  #};
  powerManagement.enable = true;

  services.minidlna.enable = true;
  services.minidlna.openFirewall = true;
  services.minidlna.settings.media_dir = [
    "V,/var/m1/1/.cache"
  ];
  services.minidlna.settings.port = 8200;
  services.minidlna.settings.inotify = "yes";
  services.minidlna.settings.friendly_name = "guinness";

  services.borgbackup.repos = {
    marvin = {
      path = "/backup/marvin";
      group = "borg";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGdv9tCrmZCeuEPKYlgL7exHsq2zxtYiYZYtZ0ug/r5 dczmer@gmail.com"
      ];
    };
    lucky = {
      path = "/backup/lucky";
      group = "borg";
      authorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICYJp/TzZf/9qQWoWMi05q5Mp1Ga8RNcjpl9sTWv5F46 dave@lucky"
      ];
    };
    guinness = {
      path = "/backup/guinness";
      group = "borg";
      authorizedKeys = [
        # TODO: this is a local vault but requires an authorized key for config.
        #       i think there is an option to use instead of supplying a dummy key.
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGdv9tCrmZCeuEPKYlgL7exHsq2zxtYiYZYtZ0ug/r5 dczmer@gmail.com"
      ];
    };
  };
  services.borgbackup.jobs.guinness = {
    user = "dave";
    paths = [
      "/etc/nixos"
      "/var/keys"
    ];
    repo = "/backup/guinness";
    compression = "auto,zstd";
    startAt = "04:00";
    encryption.mode = "none";
  };

  # Minidlna doesn't support suspend/resume.
  # Create a udev rule to force-reload it on resume.
  systemd.services.restart-minidlna = {
    description = "Restart minidlna after resume";
    wantedBy = [
      "post-resume.target"
    ];
    after = [
      "post-resume.target"
    ];
    script = ''
      systemctl --no-block restart minidlna
    '';
    serviceConfig.Type = "oneshot";
  };

  #systemd.services.raid-monitor = {
  #  description = "Mdadm RAID Monitor";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "postfix.service" ];
  #  serviceConfig.ExecStart = "${pkgs.mdadm}/bin/mdadm --monitor --scan";
  #};
  environment.etc."mdadm.conf".text = ''
    MAILADDR dave
  '';

  # XXX don't autoUpgrade for now. I think it sometimes crashes and reboots.
  ## allow autoUpgrade but don't reboot automatically
  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.dates = "04:00";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
