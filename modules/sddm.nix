{ config, pkgs, lib, ... }:
let

sddm-astronaut = pkgs.sddm-astronaut.override {
  embeddedTheme = "hyprland_kath";
};
in
{

services.xserver.enable = true;

environment.systemPackages = [
  sddm-astronaut
];

services.displayManager = {
  sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = [sddm-astronaut];
  };
  defaultSession = "hyprland";
};

}
