{
  description = "Home Manager configuration of amano_yo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
       nixpkgs,
       home-manager,
       nix-darwin,
       ...
     }:
    let
      system = "aarch64-darwin";
      # standalone な homeConfigurations 用の pkgs。allowUnfree をここで指定する
      # （darwin 統合パスは configuration.nix 側の nixpkgs.config を使う）。
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "claude-code"
            "vscode"
          ];
      };
    in
    {
      homeConfigurations."amano_yo" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home-manager/home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      darwinConfigurations."amanonoMacBook-Air" = nix-darwin.lib.darwinSystem {
         modules = [
           ./nix-darwin/configuration.nix
           # home-manager を nix-darwin モジュールとして統合。
           # これで `darwin-rebuild switch` 一発でユーザー設定も同時に適用される。
           home-manager.darwinModules.home-manager
           {
             home-manager.useGlobalPkgs = true;
             home-manager.useUserPackages = true;
             home-manager.users.amano_yo = import ./home-manager/home.nix;
           }
         ];
       };
    };
}
