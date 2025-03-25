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

# Create entry for impersistent root partition
Next up you need to create your root partition entry. Example below

```
  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [ "defaults" "mode=755" ];
    };
```

# Create user entry with password
Create an entry in configuration.nix for your user with a password set. Example can be found in hosts/nixos/configuration.nix

# Install the system
Run the command below and set a root password
```
nixos-install
reboot
```

# Login and setup the system
```
nix-shell -p git
git clone https://github.com/calle482/nix
mv nix .dotfiles
cd .dotfiles
sudo nixos-rebuild switch --flake .
```
