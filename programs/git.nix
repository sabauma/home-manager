{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userEmail = "sabauma@fastmail.com";
    userName = "Spenser Bauman";

    # Enable difftastic integration
    difftastic.enable = true;
    difftastic.background = "dark";
  };
}
