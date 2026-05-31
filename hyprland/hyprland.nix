{ pkgs, config, ... }:

let
  wallpaper = ../wallpapers/occ384clcjg51.jpg;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = { };
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  # ── Waybar (replaces xmobar) ─────────────────────────────────────────────────
  # Layout mirrors xmobar template:
  #   %StdinReader% }{ [cpu]·[mem]·[net]·[date]
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        # output = "DP-2";
        position = "top";
        height = 30;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          active-only = false;
          all-outputs = false;
          show-special = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
        };

        "hyprland/submap" = {
          format = "{}";
          max-length = 8;
          tooltip = false;
        };

        "hyprland/window" = {
          max-length = 40;
          separate-outputs = true;
        };

        cpu = {
          interval = 1;
          format = "[cpu {usage:3}%]";
        };

        memory = {
          interval = 1;
          format = "[mem {percentage}%]";
        };

        network = {
          interval = 1;
          format-ethernet = "[{ifname} ↓{bandwidthDownBytes} ↑{bandwidthUpBytes}]";
          format-wifi = "[{ifname} ↓{bandwidthDownBytes} ↑{bandwidthUpBytes}]";
          format-disconnected = "[disconnected]";
          max-length = 30;
        };

        clock = {
          format = "[{:%a %b %e %H:%M}]";
          tooltip = false;
        };
      }
    ];

    # Gruvbox dark theme — mirrors xmobarrc color scheme
    style = ''
      * {
        font-family: "Berkeley Mono";
        font-size: 18px;
        min-height: 0;
        border: none;
        border-radius: 0;
        padding: 0 2px;
        margin: 0;
      }

      window#waybar {
        background-color: #1d2021;
        color: #a89984;
      }

      #workspaces {
        padding: 0;
      }

      #workspaces button {
        color: #a89984;
        background: transparent;
        padding: 0 6px;
        border-bottom: 2px solid transparent;
      }

      /* Active workspace — xmobarCurrentWorkspaceColor (#458588 darkBlue) */
      #workspaces button.active {
        color: #458588;
        border-bottom-color: #458588;
      }

      /* Visible (on other monitor) — xmobarVisibleWorkspaceColor (#cc241d darkRed) */
      #workspaces button.visible {
        color: #cc241d;
      }

      #workspaces button.urgent {
        color: #fb4934;
      }

      #submap {
        color: #b8bb26;
        padding: 0 6px;
      }

      /* Window title — xmobarTitleColor (#b16286 darkMagenta) */
      #window {
        color: #b16286;
      }

      /* Right modules — xmobarLayoutColor (#fabd2f yellow) */
      #cpu,
      #memory,
      #network,
      #clock {
        color: #fabd2f;
      }

      /* Threshold coloring to match xmobar's -h/-l thresholds */
      #cpu.warning,
      #memory.warning {
        color: #458588;
      }

      #cpu.critical,
      #memory.critical {
        color: #fb4934;
      }
    '';
  };

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
