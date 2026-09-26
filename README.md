# dotfiles

amano_yo の macOS 環境設定。**Nix Flake + nix-darwin + Home Manager** で宣言的に管理。

Home Manager は nix-darwin のモジュールとして統合しているため、**システム設定・Homebrew・ユーザー設定を `darwin-rebuild switch` 一発で適用**できる。

## 構成

```
dotfiles/
├── flake.nix                    # エントリポイント。入力(inputs)と出力(outputs)を定義
├── flake.lock                   # 依存バージョンのロックファイル
├── nix-darwin/
│   ├── configuration.nix        # macOS システム設定のトップレベル
│   │                            #   - system.defaults（Dock 等）
│   │                            #   - users.users（Home Manager 統合用）
│   │                            #   - Touch ID sudo, nixpkgs.config など
│   └── homebrew.nix             # Homebrew で管理する cask / brew の一覧
└── home-manager/
    ├── home.nix                 # ユーザー環境のトップレベル（modules を import）
    └── modules/
        ├── git.nix              # Git 設定
        ├── zsh.nix              # シェル設定
        ├── vscode.nix           # VSCode 設定・拡張機能
        └── ghostty.nix          # Ghostty 設定
```

`flake.nix` で `home-manager.darwinModules.home-manager` を読み込み、`home.nix` を
`darwinConfigurations` に統合している（`useGlobalPkgs` / `useUserPackages` を有効化）。

## パッケージ管理の指針

| 対象 | 管理方法 | 記述場所 |
|---|---|---|
| GUI アプリ（.app） | Homebrew cask | `nix-darwin/homebrew.nix` の `casks` |
| CLI ツール・開発ツール | Nix | `home-manager/home.nix` の `home.packages` |
| nixpkgs にない CLI ツール | Homebrew | `nix-darwin/homebrew.nix` の `brews` |
| アプリの設定ファイル | Home Manager | `home-manager/modules/*.nix`（`programs.<tool>` を優先） |
| macOS システム設定 | nix-darwin | `nix-darwin/configuration.nix` |

**一言原則：「GUI アプリは brew cask、それ以外は Nix、設定は home-manager モジュール」**

## 適用方法

Home Manager を統合済みのため、**1 コマンド**で全設定（システム・Homebrew・ユーザー）を適用する。

```bash
sudo darwin-rebuild switch --flake .#amanonoMacBook-Air
```

- nix-darwin の activation は root 権限が必要（sudo）。sudo は Touch ID 認証を有効化済み。
- ビルドだけ試したい（適用しない）場合：
  ```bash
  nix build .#darwinConfigurations.amanonoMacBook-Air.system --no-link
  ```
- ユーザー設定のみ単独で適用する standalone 出力も残してある（通常は不要）：
  ```bash
  home-manager switch --flake .#amano_yo
  ```

## 新しいツールを追加するとき

### CLI ツールを追加する

`home-manager/home.nix` の `home.packages` に追加：

```nix
home.packages = with pkgs; [
  nixfmt
  claude-code
  ripgrep  # ← 追加
];
```

### GUI アプリを追加する

`nix-darwin/homebrew.nix` の `casks` に追加：

```nix
casks = [
  "ghostty"
  "notion"  # ← 追加
];
```

cask は `caskArgs.no_quarantine = true` で導入するため、初回起動時の Gatekeeper
警告（「開いてもよいですか」）は出ない（署名・notarize 済みアプリ前提）。

### アプリの設定を管理する

1. `home-manager/modules/<tool>.nix` を新規作成（`programs.<tool>` を優先して使う）
2. `home-manager/home.nix` の `imports` に `./modules/<tool>.nix` を追加

## 前提条件

- macOS（Apple Silicon / `aarch64-darwin`）
- Nix（flakes 有効。Determinate インストーラ利用のため `nix.enable = false`）
- nix-darwin インストール済み

## macOS 側で手動対応が必要なもの

Nix では宣言的に管理できず、初回のみ手動対応が要る項目：

- **アプリの権限付与**（入力監視・アクセシビリティ等）… TCC は SIP 保護のため自動化不可。
  アプリごとに「システム設定 > プライバシーとセキュリティ」で初回 1 回だけ許可する。
- **一部 cask のインストール中パスワード**… `.pkg` を含む cask のみ要求される。

## 参考（公式ドキュメント）

- [Nix / nixpkgs](https://nixos.org/) — [ダウンロード](https://nixos.org/download/)
- [nix-darwin マニュアル](https://nix-darwin.github.io/nix-darwin/manual/index.html)
- [Home Manager マニュアル](https://nix-community.github.io/home-manager/)
- [Home Manager options 検索](https://home-manager-options.extranix.com/)
- [nixpkgs パッケージ検索](https://search.nixos.org/packages)
