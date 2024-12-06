{ pkgs, ... }:
{
  programs.htop = {
    enable = true;

    settings = {
      hide_userland_threads = 0;
      highlight_base_name = 1;
      highlight_deleted_exe = 1;
      show_program_path = 0;
    };
  };
}
