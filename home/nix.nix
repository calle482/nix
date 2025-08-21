{ config, pkgs, lib, sops-nix, ... }:

{
  home.username = "calle";
  home.homeDirectory = "/home/calle";

  programs.home-manager.enable = true;

  home.stateVersion = "25.11"; # This should not be changed, keep at the version which the system was installed on

  #programs.home-manager.backupFileExtension = "backup";

  home.sessionVariables = {
    EDITOR = "vim";
  };


    # Brunmagi musstorlek
    programs.bash = {
      enable = true;

      initExtra = ''
        # include .profile if it exists
        [[ -f ~/.profile ]] && . ~/.profile
      '';
    };

  # sops
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/calle/.config/sops/age/keys.txt";
  sops.defaultSymlinkPath = "/run/user/1000/secrets";
  sops.defaultSecretsMountPoint = "/run/user/1000/secrets.d";

  imports = [
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/rofi.nix
    ./modules/mpv.nix
    ./modules/alacritty.nix
    ./modules/fonts.nix
    ./modules/theming.nix
    ./modules/virtualization.nix
    ./modules/vscodium.nix
  ];

}
