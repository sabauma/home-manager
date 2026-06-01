{ pkgs, config, ... }:

let
  wallpaper = ../wallpapers/occ384clcjg51.jpg;
in
{
  home.packages = [ pkgs.jq ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = { };
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  # ── Waybar ───────────────────────────────────────────────────────────────────
  # Config and style managed via xdg.configFile so themes can be swapped easily.
  # To try a different theme: change the two source paths below and home-manager switch.
  programs.waybar.enable = true;

  xdg.configFile."waybar/config.jsonc".source = ../waybar-themes/adapted/V7.1/config.jsonc;
  xdg.configFile."waybar/style.css".source    = ../waybar-themes/adapted/V7.1/style.css;

  # ── Mako (replaces notify-osd) ───────────────────────────────────────────────
  services.mako = {
    enable = true;
    settings = {
      background-color = "#1d2021";
      text-color = "#ebdbb2";
      border-color = "#458588";
      border-size = 2;
      font = "Berkeley Mono 14";
      timeout = 5000;
    };
  };

  # ── Hyprlock (replaces betterlockscreen) ─────────────────────────────────────
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
      background = [
        {
          color = "rgb(1d2021)";
        }
      ];
      "input-field" = [
        {
          size = "300, 50";
          position = "0, -80";
          halign = "center";
          valign = "center";
          outline_thickness = 3;
          outer_color = "rgb(458588)";
          inner_color = "rgb(282828)";
          font_color = "rgb(ebdbb2)";
          placeholder_text = "";
          check_color = "rgb(b8bb26)";
          fail_color = "rgb(cc241d)";
        }
      ];
    };
  };

  # ── Hypridle (replaces `xset dpms 3600 3600 3600; xset s off`) ───────────────
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 3600; # 1 hour, matching xset dpms 3600
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  # ── Hyprpaper (replaces feh) ──────────────────────────────────────────────────
  # Use xdg.configFile to control exact config order — ipc=on must precede
  # wallpaper entries for the 0.8.x parser to enable IPC at startup.
  services.hyprpaper.enable = true;
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    ipc=on
    splash=false
    preload=${wallpaper}
    wallpaper {
        monitor = HDMI-A-2
        path = ${wallpaper}
        fit_mode = cover
    }
    wallpaper {
        monitor = DP-2
        path = ${wallpaper}
        fit_mode = cover
    }
  '';
}
