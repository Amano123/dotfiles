{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    '';

    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
    };
  };
}
