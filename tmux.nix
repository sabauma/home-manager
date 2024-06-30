{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    aggressiveResize = true;
    customPaneNavigationAndResize = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    terminal = "xterm-256color";
    shell = "${pkgs.fish}/bin/fish";

    plugins = with pkgs.tmuxPlugins; [
      gruvbox
      prefix-highlight
      tmux-fzf
    ];

    extraConfig = ''
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # some nice pane navigation settings
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      bind-key -n C-h select-pane -L
      bind-key -n C-j select-pane -D
      bind-key -n C-k select-pane -U
      bind-key -n C-l select-pane -R

      # present a menu of URLs to open from the visible pane. sweet.
      bind-key u capture-pane \;\
      save-buffer /tmp/tmux-buffer \;\
      split-window -l 10 "urlview /tmp/tmux-buffer"
      '';
  };
}
