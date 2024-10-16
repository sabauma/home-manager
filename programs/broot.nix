_:
{
  programs.broot = {
    enable = true;
    settings = {
      verbs = [
        {
          invocation = "edit";
          key = "F2";
          shortcut = "e";
          execution = "$EDITOR {file}";
        }
        {
          key = "ctrl-p";
          execution = ":line_up";
        }
        {
          key = "ctrl-n";
          execution = ":line_down";
        }
        {
          key = "ctrl-u";
          execution = ":page_up";
        }
        {
          key = "ctrl-d";
          execution = ":page_down";
        }
        {
          invocation = "git_add";
          shortcut = "ga";
          key = "ctrl-a";
          leave_broot = false;
          execution = "git add {file}";
          apply_to = "file";
        }
      ];
    };
  };
}
