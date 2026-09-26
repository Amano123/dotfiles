{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "amano_yo";
      user.email = "39152214+Amano123@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
