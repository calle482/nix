{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      steam
      lutris
      osu-lazer-bin
      prismlauncher
  ];

}
