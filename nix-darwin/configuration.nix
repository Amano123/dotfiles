{ config, pkgs, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  system.primaryUser = "amano_yo";
  nixpkgs.hostPlatform = "aarch64-darwin";

  # home-manager 統合時、home.homeDirectory はこのユーザー定義から導出される。
  users.users.amano_yo = {
    name = "amano_yo";
    home = "/Users/amano_yo";
  };

  # home-manager を統合し useGlobalPkgs = true にしたため、
  # allowUnfree はグローバル（darwin 側）の nixpkgs で指定する。
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "claude-code"
      "vscode"
    ];
  system.stateVersion = 6;
  nix.enable = false;
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.dock.persistent-apps = [
    # Finder は macOS が Dock 左端に常に自動表示するため、ここに入れると重複する
    "/Applications/Ghostty.app"
    "/Applications/Google Chrome.app"
    "/Applications/Obsidian.app"
    "/Applications/Claude.app"
    "/Applications/ChatGPT.app"
    "/System/Applications/System Settings.app"
  ];
}
