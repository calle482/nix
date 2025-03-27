# Initial installation with impermanence guide
```
sudo su
loadkeys sv-latin1
git clone https://github.com/calle482/nix
cd nix
```

Edit the disk varaible in initial_setup.sh to the disk you wish to use for installation.

```
chmod +x initial_setup.sh
./initial_setup.sh
```

## configuration.nix modifications
Next up you need to create your root partition entry. Example below

```
  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "mode=755" ];
    };
```

Enable networkmanager & SSH in configuration.nix

```
networking.networkmanager.enable = true;
services.openssh.enable = true;
```

Set needed for boot parameter on /persistent

```
  fileSystems."/persistent" =
    { device = "/dev/disk/by-uuid/67326321-a8df-4cc5-860e-0ccb89014eea";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=persistent" ];
    };
```

## Create user entry with password
Create an entry in configuration.nix for your user with a password set. Example can be found in hosts/nixos/configuration.nix

```
users.users.calle = {
  isNormalUser = true;
  description = "calle";
  hashedPassword = "$6$zz5.EZMDjqHoXaeU$2rxBO2RzliIic7E1Rxau/3FudYlm5c1x3LId1KB29LOJZ/T6pDy6Ta.s6jZbduIOhfOu1VWR.eelDngVvSGke0";
  extraGroups = [ "networkmanager" "wheel" ];
  packages = with pkgs; [];
};
```

## Install the system
Run the command below and set a root password
```
nixos-install
reboot
```

## Login and setup the system
```
nix-shell -p git
git clone https://github.com/calle482/nix
mv nix .dotfiles
cd .dotfiles
```

### Fix hardware-configuration.cfg
Fix the UUID for the filesystems. UUIDs in the hardware-configuration.nix will not be correct when the system is rebuilt from zero.

```
  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };

  fileSystems."/persistent" =
    { device = "/dev/disk/by-uuid/ac8b82d3-4cb5-4fa5-b8cf-34a5d36a64a5";
      fsType = "btrfs";
      neededForBoot = true;
      options = [ "subvol=persistent" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/ac8b82d3-4cb5-4fa5-b8cf-34a5d36a64a5";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/ac8b82d3-4cb5-4fa5-b8cf-34a5d36a64a5";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/83E5-A630";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
```


### Rebuild the system
```
sudo nixos-rebuild switch --flake .
```


# Setup sops-nix age key
sudo nix run nixpkgs#ssh-to-age -- -private-key -i /home/calle/.ssh/server_key > ~/keys.txt
sudo nix shell nixpkgs#age -c age-keygen -y ./keys.txt
age1qf92uhsvu45cvf93k0mmaefmk95v5ev6nq46szpz27lh2x4x6qmqez5m5m
