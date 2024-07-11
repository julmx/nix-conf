{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "julmx";
    userEmail = "julmx@sl.erucipe.net";
  };
}