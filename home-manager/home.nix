{ config, pkgs, ... }:

{
  imports = [
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
    ./modules/ghostty.nix
  ];

  home.username = "amano_yo";
  home.homeDirectory = "/Users/amano_yo";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nixfmt
    claude-code
    uv
    gh
  ];

  programs.home-manager.enable = true;
}
