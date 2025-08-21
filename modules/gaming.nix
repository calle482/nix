{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      lutris
      osu-lazer-bin
      prismlauncher
      protonup-qt
  ];

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  programs.steam.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

}
