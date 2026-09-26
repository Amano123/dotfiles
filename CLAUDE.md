# CLAUDE.md

このリポジトリのルールは [AGENTS.md](./AGENTS.md) に一元化している（Claude Code / Codex 共通、二重管理を避けるため）。

**作業前に必ず [AGENTS.md](./AGENTS.md) を読んで従うこと。**

- 詳細な判断フロー・検証ワークフローは nix-darwin Skill（`.claude/skills/nix-darwin/SKILL.md`）を参照。
- パッケージ名・option 名は公式検索（search.nixos.org 等）か `nix build` のビルド確認で検証する。
- Nix 変更のレビューが必要なときは `nix-reviewer` サブエージェントを使う。
