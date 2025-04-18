{ pkgs, config, ... }:
{

  qt.style.name = "adwaita-dark";
  ##gtk.theme.name = "adwaita-dark";


  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
