---
name: nix-darwin
description: Manage this macOS dotfiles repo (Nix flake + nix-darwin + Home Manager + Homebrew). Use when adding or removing packages/apps, changing macOS system settings, editing any .nix file, or deciding whether something belongs in nixpkgs, Home Manager, nix-darwin, or Homebrew. Covers package routing, the build/validate/switch workflow, and safety rules.
---

# nix-darwin dotfiles management

amano_yo の macOS dotfiles を Nix で正しく変更するための判断ルールとワークフロー。
リポジトリ全体の一次ルールは [AGENTS.md](../../../AGENTS.md) にある。この Skill はその実行手順を補う。

## 大原則

1. **option/package 名を記憶で断定しない**。公式検索（[search.nixos.org](https://search.nixos.org/packages) / [Home Manager options](https://home-manager-options.extranix.com/) / [nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/index.html)）で確認するか、適用前の `nix build ... --no-link` で評価エラーとして捕まえる。存在しない option/package を書かない。
2. **宣言的に変更する**。`brew install` や `nix-env -i` を直接叩かず、必ず設定ファイルに宣言して rebuild する。
3. **ビルド確認 → レビュー → 適用**の順を必ず守る。

## リポジトリ構成（変更対象）

- `nix-darwin/configuration.nix` — macOS システム設定（defaults, users, launchd 等）
- `nix-darwin/homebrew.nix` — Homebrew の cask / brew / masApps
- `home-manager/home.nix` — ユーザー環境のトップレベル（`home.packages` と modules の import）
- `home-manager/modules/*.nix` — ツールごとの設定（`programs.<tool>`）
- `flake.nix` — inputs/outputs。home-manager は nix-darwin に統合済み

## 手順の詳細

- 何をどこに入れるか → [package-routing.md](./package-routing.md)
- Homebrew の使い分けと設定方針 → [homebrew.md](./homebrew.md)
- 変更〜適用の検証ワークフロー → [validation.md](./validation.md)

## 安全ルール（AGENTS.md より）

- `brew install` を直接実行しない（`homebrew.nix` に宣言 → rebuild）
- imperative install（`nix-env -i` 等）禁止、宣言的変更を優先
- `stateVersion` を不用意に変更しない
- secrets を Nix store に平文で入れない
- hash を推測しない（実ビルドで確定）
- 破壊的 cleanup（`onActivation.cleanup = "uninstall"/"zap"`）を勝手に有効化しない
