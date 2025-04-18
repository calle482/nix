{ config, pkgs, lib, ... }:
let
  terminal-bin = "${pkgs.kitty}/bin/kitty";
  browser = "${pkgs.librewolf-bin}/bin/librewolf";
in
{

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland.enable = true; # enable Hyprland

wayland.windowManager.hyprland.settings = {

  "$mod" = "SUPER";

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

  bind = [
    "$mod, Return, exec, ${terminal-bin}"
    "$mod, Q, killactive"
    "$mod, N, exec, ${browser}"

    # Move focus with mod + arrow keys
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    #Move window with arrow keys
    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"


    # Switch workspaces with mod + [0-9]
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod, 0, workspace, 10"

    # Move active window to a workspace with mod + SHIFT + [0-9]
    "$mod SHIFT, 1, movetoworkspacesilent, 1"
    "$mod SHIFT, 2, movetoworkspacesilent, 2"
    "$mod SHIFT, 3, movetoworkspacesilent, 3"
    "$mod SHIFT, 4, movetoworkspacesilent, 4"
    "$mod SHIFT, 5, movetoworkspacesilent, 5"
    "$mod SHIFT, 6, movetoworkspacesilent, 6"
    "$mod SHIFT, 7, movetoworkspacesilent, 7"
    "$mod SHIFT, 8, movetoworkspacesilent, 8"
    "$mod SHIFT, 9, movetoworkspacesilent, 9"
  ];

};

}
