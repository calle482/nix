{ config, pkgs, lib, ... }:

{

    environment.systemPackages = with pkgs; [
      #discord
      vesktop
      spotify
      xfce.thunar
      ffmpegthumbnailer # Needed for thumbnails in thunar
      xfce.tumbler # Needed for thumbnails in thunar
      gnome-system-monitor
      pavucontrol
      obs-studio
      baobab
      dconf
      docker
      docker-compose
      gedit
      killall
      brave
      gnome-calculator
      neofetch
  ];

  # Needed for swaylock to work - otherwise wont accept password even though it's correct
  security.pam.services.swaylock = {};

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
    };
  };

programs.firefox = {
  enable = true;
  package = pkgs.librewolf;
  policies = {
    ExtensionSettings = {
      # Ublock Origin - Addon
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "force_installed";
      };
      # Bitwarden Password Manager
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        installation_mode = "force_installed";
      };
      # Dark Reader
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "force_installed";
      };
      # Return Youtube Dislikes
      "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
        installation_mode = "force_installed";
      };
      # Sponsorblock
      "sponsorBlocker@ajay.app" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
        installation_mode = "force_installed";
      };
      # Youtube Auto HD + FPS
      "avi6106@gmail.com" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-auto-hd-fps/latest.xpi";
        installation_mode = "force_installed";
      };
      # AMOLED Theme
      "{38bbd5d5-5030-42c7-823b-05bf8a3ea075}" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/amoled-theme/latest.xpi";
        installation_mode = "force_installed";
      };
      };
    };
  };

}
