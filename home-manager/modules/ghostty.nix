{ ... }:

{
  # ghostty 本体は brew cask で管理。ここでは設定ファイルのみ管理する
  home.file.".config/ghostty/config".text = ''
    # Ghostty configuration
    # Reference: https://ghostty.org/docs/config/reference
  '';
}
