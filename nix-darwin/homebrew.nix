{ ... }:

{
  homebrew = {
    enable = true;

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

  # Homebrew 5.0 で --no-quarantine（caskArgs.no_quarantine）が廃止され効かなくなったため、
  # brew bundle 実行後に Homebrew Cask 由来の quarantine 属性だけを外す。
  # onActivation.upgrade で cask が更新されると再付与されるので、毎回の switch で実行する。
  # （署名・notarize 済み正規アプリ前提。他経路でダウンロードしたアプリには触れない）
  system.activationScripts.postActivation.text = ''
    echo "removing Homebrew Cask quarantine attributes..." >&2
    for app in /Applications/*.app; do
      if /usr/bin/xattr -p com.apple.quarantine "$app" 2>/dev/null | /usr/bin/grep -q "Homebrew Cask"; then
        # activate は set -e なので、失敗しても switch 全体を止めない
        /usr/bin/xattr -dr com.apple.quarantine "$app" \
          || echo "warning: failed to remove quarantine from $app" >&2
      fi
    done
  '';
}
