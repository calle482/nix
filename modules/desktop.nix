{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      librewolf-bin
      discord
      spotify
      xfce.thunar
      gnome-system-monitor
  ];



}
