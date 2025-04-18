{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      librewolf-bin
      discord
      spotify
      xfce.thunar
      gnome-system-monitor
      pavucontrol
      obs-studio
      baobab
      dconf
  ];


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };



}
