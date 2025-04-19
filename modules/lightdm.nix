{ config, pkgs, lib, ... }:

{

  services.xserver.enable = true;

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
    };

  };

}
