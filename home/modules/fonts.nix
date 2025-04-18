{ pkgs, config, lib, ... }:

{

  # Install Nerd Fonts
  home.packages = [
    # Include other packages you want here
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontconfig.enable = true;


}
