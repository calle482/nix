{ config, pkgs, lib, ... }:

{

  environment.systemPackages = [
    pkgs.recyclarr
  ];
}
