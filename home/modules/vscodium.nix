{ pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = true;
    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.redhat.vscode-yaml
        #pkgs.vscode-extensions.redwan-hossain.skillavid-pure-black
        pkgs.vscode-extensions.vscodevim.vim
      ];
      userSettings = {
        "git.enableSmartCommit" =true;
        "git.confirmSync" = false;
        "redhat.telemetry.enabled" = false;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "workbench.colorTheme" = "SkillAvid Pure Black";
        "files.associations" = {
            "*.yml" = "yaml";
        };
        "[nix]" = {
            "editor.insertSpaces" = true;
            "editor.tabSize" = 2;
        };
        "diffEditor.ignoreTrimWhitespace" = true;
      };
    };
  };

}
