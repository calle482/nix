{ config, pkgs, lib, ... }:

{

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

wayland.windowManager.hyprland.settings = {

  # Keyboard
  input = {
    kb_layout = "se";
    follow_mouse = 1;
  };

  # Floating Windows
  windowrulev2 = [
   "float, class:^(org.pulseaudio.pavucontrol)"
   "float, class:^()$,title:^(Picture in picture)$"
   "float, class:^()$,title:^(Save File)$"
   "float, class:^()$,title:^(Open File)$"
   "float, class:^(LibreWolf)$,title:^(Picture-in-Picture)$"
   "float, class:^(blueman-manager)$"
   "float, class:^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde|xdg-desktop-portal-hyprland)(.*)$"
   "float, class:^(polkit-gnome-authentication-agent-1|hyprpolkitagent|org.org.kde.polkit-kde-authentication-agent-1)(.*)$"
   "float, class:^(CachyOSHello)$"
   "float, class:^(zenity)$"
   "float, class:^()$,title:^(Steam - Self Updater)$"
  ];

};

}
