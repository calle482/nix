{ config, pkgs, pkgs-unstable, lib, ... }:
{

  imports = [
      ./hardware-configuration.nix
      ../../modules/media.nix
     # ../../modules/minecraft_server.nix
      ../../modules/caddy.nix
      ../../modules/zram.nix
      ../../modules/docker.nix
      ../../modules/nvidia.nix
     # ../../modules/samba.nix
    ];

  # Enable crashdump
  boot.crashDump.enable = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # AMD + Linux = :(
  boot.kernelParams = [ "processor.max_cstate=5" ];

  # Cleanup
  #nix.settings.auto-optimise-store = true;
  #nix.gc.automatic = true;
  #nix.gc.dates = "daily";
  #nix.gc.options = "--delete-older-than 365d";

  # CPU Governor
  powerManagement = {
    cpuFreqGovernor = "performance";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixlab"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable firewall
  networking.firewall = {
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.calle = {
    isNormalUser = true;
    description = "calle";
    hashedPassword = "$6$8oHryG9/cFmb5L2.$fPpF/rPin4q1OnZP9YTYVxDokdhO5G1kv55tdfQyZPkdT8wURc4Do1pLs3bzIJ.AX4jDY.1yanIatIIeZ72xg1";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    dig
    htop
    sops
    lynis
    cryptsetup
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Impermanence
  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/luks-keys"
      "/etc/NetworkManager/system-connections"
      "/mnt"
      #"/run/secrets.d"
      { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
    ];
    files = [
      "/etc/machine-id"
      "/root/myVPNprovider.conf"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
    ];
  };

  # sops
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/calle/.config/sops/age/keys.txt";

  # Auto upgrade
  system.autoUpgrade = {
    enable = true;
    flake = "github:calle482/nix";
    dates = "Mon *-*-* 03:00:00"; # Every monday at 03:00
    allowReboot = true;
  };

  # Encrypted drive
  #boot.initrd.systemd.enable = true;
  #boot.initrd.luks.devices."crypt18TB-HDD" = {
  #  device = "/dev/disk/by-uuid/f410dd27-a4af-4b34-b48c-c05f6f3f8ca6";
  #  keyFileSize = 8192;
  #  keyFile = "/etc/luks-keys/18TB-HDD_key";
  #};

  #fileSystems."/mnt/18tb" = {
  #  device = "/dev/mapper/crypt18TB-HDD";
  #  fsType = "ext4";
  #  options = [ "nofail" ];
  #};

environment.etc."crypttab".text = ''
  crypt24TB-HDD /dev/disk/by-uuid/f410dd27-a4af-4b34-b48c-c05f6f3f8ca6 /etc/luks-keys/24TB-HDD-01_key luks
  crypt4TB-HDD /dev/disk/by-uuid/28b6369b-1906-4aea-bf93-078d1542dc90 /etc/luks-keys/4TB-HDD_key luks
'';

fileSystems."/mnt/18tb" = {
  device = "/dev/mapper/crypt24TB-HDD";
  fsType = "ext4";
  options = [ "nofail" ];
};

fileSystems."/mnt/4tb" = {
  device = "/dev/mapper/crypt4TB-HDD";
  fsType = "ext4";
  options = [ "nofail" ];
};

}
