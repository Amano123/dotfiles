# Package routing — 何をどこに入れるか

新しいソフトウェアを追加するときの判断フロー。まず存在確認（search.nixos.org 等）してから決める。

## 判断フロー

```
追加したいものは何？
│
├─ CLI ツール？
│   └─ nixpkgs にある？ (search.nixos.org で検索)
│        ├─ ある → home-manager/home.nix の home.packages に追加
│        └─ ない → nix-darwin/homebrew.nix の brews に追加
│
├─ ユーザー設定を伴うツール（shell/git/editor/terminal 等）？
│   └─ Home Manager module はある？ (home-manager-options で programs.<tool> を確認)
│        ├─ ある → home-manager/modules/<tool>.nix を作り programs.<tool> で設定
│        │          → home.nix の imports に ./modules/<tool>.nix を追加
│        └─ ない → home.packages に本体だけ入れ、設定は home.file 等で管理
│
├─ GUI アプリ（.app）？
│   ├─ Nix で素直に動く（nixpkgs にあり Darwin 対応）→ Nix
│   └─ 配布形態が特殊 / Nix で壊れやすい → homebrew.nix の casks
│
├─ Mac App Store のアプリ？
│   └─ homebrew.nix の masApps に { "App名" = <id>; }
│
├─ macOS システム設定（Dock/Finder/キーボード/launchd 等）？
│   └─ nix-darwin/configuration.nix の system.defaults / launchd 等
│      (option 名は nix-darwin options マニュアルで確認)
│
└─ その場だけ使いたい / 恒久インストール不要？
    └─ nix shell nixpkgs#<pkg>  または  nix run nixpkgs#<pkg>
```

## 追加例

### CLI ツール（nixpkgs）
```nix
# home-manager/home.nix
home.packages = with pkgs; [
  ripgrep  # ← 追加
];
```

### GUI アプリ（brew cask）
```nix
# nix-darwin/homebrew.nix
casks = [
  "notion"  # ← 追加
];
```

### ツール設定（Home Manager module）
```nix
# home-manager/modules/<tool>.nix を新規作成
{ ... }:
{
  programs.<tool> = {
    enable = true;
    # 設定は home-manager-options で option を確認しながら書く
  };
}
```
→ `home-manager/home.nix` の `imports` に `./modules/<tool>.nix` を追加。

## 迷ったときの優先順位

nixpkgs / Home Manager で扱える → **Nix を優先**。
Nix だと不安定 / 未対応 / 手間が大きい GUI → **Homebrew cask**。
Homebrew も nix-darwin 配下（`homebrew.nix`）で宣言的に管理するので、「Nix か Homebrew か」ではなく「Homebrew も Nix 構成の一部」と捉える。
