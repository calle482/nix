{ config, ... }:

{

  environment.systemPackages = with pkgs; [
    mullvad
    mullvad-vpn
  ];

  services.mullvad-vpn = {
    enable = true;
  };

}
