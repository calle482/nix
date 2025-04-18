{ config, pkgs, lib, ... }:

{

services.xserver.enable = true;

services.displayManager.sddm = {
  enable = true;
};

}
