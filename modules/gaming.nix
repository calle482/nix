{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      steam
      lutris
      osu-lazer-bin
      prismlauncher
      protonup-qt
      ananicy-cpp
      ananicy-rules-cachyos
  ];

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

}
