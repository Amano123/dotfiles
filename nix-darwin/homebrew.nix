{ ... }:

{
  homebrew = {
    enable = true;

    # cask を quarantine せずに入れる（署名・notarize 済み正規アプリ前提）。
    # これで新規インストールしたアプリの初回起動時 Gatekeeper 警告が出なくなる。
    caskArgs.no_quarantine = true;

    brews = [
      # nixpkgs にない CLI ツールのみここに追加する
      "ollama"
      # libCore.so が Homebrew Python 3.10 フレームワークにリンクされているため必要
      "python@3.10"
    ];

    casks = [
      # GUI アプリ（.app 形式）はここで管理する
      "ghostty"
      "google-chrome"
      "slack"
      "obsidian"
      "google-japanese-ime"
      "sol"
      # visual-studio-code は home-manager の programs.vscode で管理
      "claude"
      "chatgpt"
      "openlogi"
    ];

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };
  };
}
