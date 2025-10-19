{ pkgs, ... }:
let
  # List of global excludes for .gitignore
  excludesFile = pkgs.writeText "gitignore" ''
    .envrc
    .direnv/*
  '';
in
{
  home.packages = with pkgs; [
    git-absorb
    git-lfs
  ];

  programs.difftastic = {
    enable = true;
    options.background = "dark";
  };

  programs.git = {
    enable = true;

    settings.user.email = "spenser@modular.com";
    settings.user.name = "Spenser Bauman";

    lfs.enable = true;

    settings = {
      # Automatically update submodules when performing git pull
      submodule.recurse = true;

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

      help.autocorrect = 1;
      column.ui = "auto";
      commit.verbose = true;
      core.fsmonitor = true;
      core.untrackedcache = true;
      core.excludesfile = "${excludesFile}";
    };
  };
}
