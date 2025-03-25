#!/run/current-system/sw/bin/bash

# Define the disk variable
DISK="/dev/vda"

# Create GPT partition table
parted $DISK -- mklabel gpt

# Create the ESP partition
parted $DISK -- mkpart ESP fat32 1MB 1536MB
parted $DISK -- set 1 esp on

# Create the root partition
parted $DISK -- mkpart root 1536MB 100%

# Format the partitions
mkfs.fat -F 32 -n boot ${DISK}1
mkfs.btrfs -L nixos ${DISK}2

# Mount the root partition
mkdir -p /mnt
mount ${DISK}2 /mnt

# Create Btrfs subvolumes
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/persistent

# Unmount the root partition
umount /mnt

# Create mount points for the subvolumes
mkdir -p /mnt/{home,nix,persistent,boot}

# Mount the subvolumes with compression
mount -o compress=zstd,subvol=nix ${DISK}2 /mnt/nix
mount -o compress=zstd,subvol=home ${DISK}2 /mnt/home
mount -o compress=zstd,subvol=persistent ${DISK}2 /mnt/persistent

# Mount the ESP partition
mount ${DISK}1 /mnt/boot
