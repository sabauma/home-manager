{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      # Don't print a new line at the start of the prompt
      add_newline = false;

      # Wait 10 milliseconds for starship to check files under the current directory.
      scan_timeout = 10;
      command_timeout = 500;

      username = {
        style_user = "blue";
        style_root = "bold black";
        format = "[$user]($style)";
        disabled = false;
        show_always = true;
      };

      time = {
        disabled = false;
        style = "cyan";
        format = "[\\[ $time \\]]($style) ";
        time_format = "%T";
        utc_time_offset = "local";
      };

      hostname = {
        ssh_only = false;
        format = "[@](dimmed red)[$hostname](bold green) ";
        trim_at = ".companyname.com";
        disabled = false;
      };

      directory = {
        truncation_length = 8;
      };

      # Disable annoying features
      cmd_duration = {
        disabled = true;
      };
      python = {
        disabled = true;
      };
      julia = {
        disabled = true;
      };
      conda = {
        disabled = true;
      };
      vlang = {
        disabled = true;
      };
      nodejs = {
        disabled = true;
      };
    };
  };
}
