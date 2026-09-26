# Homebrew の使い分けと設定方針

nix-darwin は Homebrew Bundle を正式に統合しており、`homebrew.*` で cask / brew / masApps を宣言的に管理できる。「Nix を使うなら Homebrew 禁止」ではなく、**Homebrew も nix-darwin 配下に置く**のが macOS では現実的。

## 何を Homebrew に置くか

| 対象 | 置き場所 |
|---|---|
| Nix で壊れやすい / 配布形態が特殊な GUI アプリ | `casks` |
| nixpkgs にない CLI（brew formula のみ存在） | `brews` |
| Mac App Store アプリ | `masApps`（`{ "名前" = <id>; }`） |

Nix で素直に動く CLI / GUI は Nix 側（nixpkgs / Home Manager）を優先する。

## 現在の設定（nix-darwin/homebrew.nix）

- `caskArgs.no_quarantine = true;`
  cask を quarantine せずに導入 → 署名・notarize 済みアプリの初回起動 Gatekeeper 警告を抑制。
- `onActivation` は現在:
  ```nix
  onActivation = {
    autoUpdate = true;
    upgrade = true;
    cleanup = "none";
  };
  ```

## cleanup の選択肢（変更は慎重に）

| 値 | 挙動 |
|---|---|
| `"none"` | 宣言外の brew を放置（現状） |
| `"check"` | 宣言外の brew があると activation を**失敗させて教える**（自動削除しない・安全） |
| `"uninstall"` | 宣言外の brew を自動アンインストール |
| `"zap"` | アンインストール + 関連データも削除（**破壊的**） |

`"check"` は「宣言外のものを気づける」ので有用だが、`cleanup` の変更・特に `uninstall`/`zap` への変更は**ユーザー確認を取ってから**行う（安全ルール）。

## さらに再現性を高めたい場合（任意）

- `nix-homebrew` を使うと Homebrew 本体と tap 自体を pin できる。実際の formula/cask 管理は引き続き `homebrew.*` に任せる設計。導入はユーザーの意向を確認してから。
