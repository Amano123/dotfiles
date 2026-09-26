# AGENTS.md

amano_yo の macOS dotfiles（**Nix Flake + nix-darwin + Home Manager + Homebrew**）を管理する AI 向けの一次ルール。Claude Code / Codex 共通。詳細ワークフローは nix-darwin Skill（`.claude/skills/nix-darwin/`）を参照。

## パッケージ名・option 名の確認（最重要）

- パッケージ名・option 名を**学習済み知識だけで断定しない**（存在しない option/package を幻覚しない）。
- 存在確認は次のいずれかで行う: [search.nixos.org](https://search.nixos.org/packages) / [Home Manager options](https://home-manager-options.extranix.com/) / [nix-darwin options](https://nix-darwin.github.io/nix-darwin/manual/index.html) を参照するか、**適用前に必ず `nix build ... --no-link` でビルド確認**して評価エラーで捕まえる（下記ワークフロー参照）。

## パッケージの置き場所（上から順に検討）

1. **CLI ツール** → nixpkgs（`home-manager/home.nix` の `home.packages`）
2. **ユーザー設定**（shell / git / ghostty 等）→ Home Manager module（`home-manager/modules/*.nix`、`programs.<tool>` を優先）
3. **macOS システム設定 / defaults / launchd** → nix-darwin（`nix-darwin/configuration.nix`）
4. **Nix で扱いやすい GUI** → Nix
5. **Nix で壊れやすい / 配布形態が特殊な GUI** → Homebrew cask（`nix-darwin/homebrew.nix` の `casks`）
6. **nixpkgs にない brew formula** → `homebrew.nix` の `brews`
7. **Mac App Store アプリ** → `homebrew.masApps`
8. **一時利用** → `nix shell` / `nix run`（恒久インストールしない）

## 変更ワークフロー（必ずこの順）

1. 変更（新規ファイルは先に配置し、`home.nix` / `configuration.nix` の `imports` に追加）
2. `nixfmt` で整形
3. `nix build .#darwinConfigurations.amanonoMacBook-Air.system --no-link` でビルド確認
4. diff / ビルド結果をレビュー
5. `sudo darwin-rebuild switch --flake .#amanonoMacBook-Air` で適用（system + Home Manager + Homebrew を 1 コマンドで適用）

## 安全ルール

- `brew install` / `brew install --cask` を**直接実行しない**。必ず `homebrew.nix` に宣言 → rebuild。
- `nix-env -i` 等の imperative なインストールをしない。宣言的変更を優先。
- `system.stateVersion` / `home.stateVersion` を不用意に変更しない。
- secrets を Nix store に平文で入れない。
- hash を推測で書かない（実ビルドで確定させる）。
- 破壊的な cleanup（`homebrew.onActivation.cleanup = "uninstall" / "zap"` 等）を勝手に有効化しない。
