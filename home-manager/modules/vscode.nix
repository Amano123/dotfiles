{ ... }:

{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      extensions = [ ];
      userSettings = { };
    };
  };
}
