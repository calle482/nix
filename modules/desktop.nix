{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs[
      librewolf-bin
      discord
      spotify
      thunar
  ];



}
