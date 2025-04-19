{ pkgs, config, ... }:
{

  qt.style.name = "adwaita-dark";


  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    font = {
      package = pkgs.roboto;
      name = "JetBrainsMono Nerd Font Mono 12";
    };
    cursorTheme = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
    };
    #cursorTheme = {
    #  package = pkgs.kdePackages.breeze;
    #  name = "breeze";
    #};
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
  };

}
