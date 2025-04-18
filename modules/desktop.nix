{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      librewolf-bin
      #discord
      vesktop
      spotify
      xfce.thunar
      gnome-system-monitor
      pavucontrol
      obs-studio
      baobab
      dconf
      docker
      docker-compose
      gedit
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
