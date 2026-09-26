{ ... }:

{
  programs.ssh = {
    enable = true;
    # home-manager のデフォルト Host * ブロックは使わない（将来削除予定のため）
    enableDefaultConfig = false;
    # github.com への接続には ~/.ssh/github を使う（GitHub 登録鍵: macbook_air）
    settings."github.com" = {
      IdentityFile = "~/.ssh/github";
      IdentitiesOnly = true;
    };
  };
}
