{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-absorb
    git-lfs
  ];

  programs.git = {
    enable = true;
    userEmail = "spenser@modular.com";
    userName = "Spenser Bauman";

    lfs.enable = true;

    # Enable difftastic integration
    difftastic = {
      enable = true;
      background = "dark";
    };

    extraConfig = {
      # Sort branches by commit date rather than alphabetically
      branch.sort = "-committerdate";

      # Better diff algorithm
      diff.algorithm = "histogram";

      # Default to 'main' over 'master'
      init.defaultBranch = "main";

      # Better conflict format
      merge.conflictstyle = "zdiff3";

      # Don't make me set up the remote
      push.autoSetupRemote = true;

      # Don't make me stash before a rebase
      rebase.autostash = true;

      # Automatically delete remote tracking branches that have been deleted
      fetch.prune = true;
      fetch.prunetags = true;

      # Each checking of repo state
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
      transfer.fsckobjects = true;
    };
  };
}
