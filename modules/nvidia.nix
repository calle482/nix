{ config, pkgs, lib, pkgs-unstable, ... }:

{

  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
    nvidia-vaapi-driver
    nvidia-docker
    nvidia-container-toolkit
  ];

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  services.xserver.enable  = true;

  #boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia_drm.fbdev=0" ];

  hardware.nvidia = {
    open = false;
    modesetting.enable = false;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
  };

hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  	
}

