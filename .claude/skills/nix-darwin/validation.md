# 変更〜適用の検証ワークフロー

Nix 設定を変更したら、必ずこの順で検証してから適用する。

## 手順

### 1. 編集
- 新規 `.nix` ファイルは作成後、`home.nix` / `configuration.nix` の `imports` に追加する（追加漏れは評価エラーになる）。
- option 名・型は公式検索（search.nixos.org / home-manager-options / nix-darwin options）で確認する。

### 2. 整形
```bash
nixfmt <編集したファイル>.nix
```
（`nixfmt` は `home.packages` に入っている）

### 3. ビルド確認（適用しない）
```bash
nix build .#darwinConfigurations.amanonoMacBook-Air.system --no-link
```
- ここで評価エラー・型エラー・欠けている option を検出する。
- home-manager も統合されているので、この build にユーザー設定分も含まれる。

### 4. diff / 結果レビュー
- 変更したファイルの差分を確認。
- 意図しない option 変更・`stateVersion` 変更・破壊的 cleanup が混ざっていないか確認。

### 5. 適用
```bash
sudo darwin-rebuild switch --flake .#amanonoMacBook-Air
```
- 1 コマンドで system 設定 + Home Manager + Homebrew を適用。
- sudo は Touch ID 認証（設定済み）。

## トラブル時

- `home.homeDirectory ... null` 等 → `configuration.nix` の `users.users.amano_yo` 定義を確認。
- unfree エラー → `configuration.nix` の `nixpkgs.config.allowUnfreePredicate` に対象名を追加。
- Dock に重複 → 適用直後の一過性。`killall Dock` で解消（`persistent-apps` に Finder を入れない）。

## やってはいけない

- ビルド確認をスキップしていきなり `switch` する。
- `brew install` / `nix-env -i` を直接叩く。
- hash を推測で埋める（実ビルドで確定させる）。
