{ config, pkgs, lib, ... }:
let
  terminal-bin = "${pkgs.alacritty}/bin/alacritty";
  browser = "${pkgs.librewolf-bin}/bin/librewolf";
in
{
  programs.alacritty.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    # set the flake package
    package = pkgs.hyprland;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "swaylock";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "swaylock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {

    "$mod" = "SUPER";

    # Monitor
    monitor = [
      "Virtual-1, 1920x1080, 0x0, 1"
    ];

    # Keyboard
    input = {
      kb_layout = "se";
      follow_mouse = 1;
    };

    exec-once = [
      #"${pkgs.waybar}/bin/waybar"
    ];

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
     "float, class:^(zenity)$"
     "float, class:^()$,title:^(Steam - Self Updater)$"

      # Assign programs to specific workspaces
      "workspace 1, class:(librewolf)"
      "workspace 3, class:(discord)"
      "workspace 3, class:(vesktop)"
      "workspace 4, class:(Spotify)"
      "workspace 5, class:(alacritty)"
      "workspace 6, class:(Steam)"
      "workspace 10, class:(obs)"
    ];

    bind = [
      "$mod, Return, exec, ${terminal-bin}"
      "$mod, Q, killactive"
      "$mod, N, exec, ${browser}"
      "$mod, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons -icon-theme Paprius"
      "$mod SHIFT, E, exit"
      "$mod, L, exec, ${pkgs.swaylock}/bin/swaylock"

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

    animations = {
      enabled = true;
      animation = [
        "workspaces,1,2,default"
        "windows,1,1,default"
        "fade,1,3,default"
        "border,1,1,default"
        "borderangle,1,1,default"
      ];
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 7;
        passes = 4;
        xray = true;
        ignore_opacity = false;
        new_optimizations = true;
        noise = 0.02;
        contrast = 1.05;
        brightness = 1.3;
      };
      shadow = {
        enabled = true;
        range = 20;
        render_power = 2;
        color = "0x99000000";
        color_inactive = "0x55000000";

      };
      # drop_shadow = false;
      # shadow_range = 20;
      # shadow_render_power = 2;
      # shadow_offset = "3 3";
      # "col.shadow" = "0x99000000";
      # "col.shadow_inactive" = "0x55000000";
      active_opacity = 1.0;
      inactive_opacity = 0.85;
      fullscreen_opacity = 1.0;
    };

};

}
