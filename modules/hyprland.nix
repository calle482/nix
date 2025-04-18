{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      #rofi-wayland
      papirus-icon-theme
  ];



}
