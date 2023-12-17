{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))

    (import (builtins.fetchTarball {
      url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
    }))

    ((builtins.getFlake "github:sabauma/mlir.nix").overlay)
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "spenser";
  home.homeDirectory = "/home/spenser";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Allow unfree software to be installed
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # From github:sabauma/mlir-nix
    mlir

    nerdfonts

    # Useful command line tools
    bat
    bitwarden-cli
    bottom
    broot
    cachix
    coreutils
    datamash
    eza
    fd
    ffmpeg
    fzf
    git
    htop
    hyperfine
    mosh
    neovim-nightly
    newsboat
    openconnect
    pyright
    ranger
    ripgrep
    starship
    tmux
    vim_configurable
    xmobar
    yt-dlp

    ccache
    clang-tools_16

    # Preferred shell
    fish

    # Graphical programs
    (alacritty)
    (chromium)
    (discord)
    (latest.firefox-beta-bin)
    # (nixGLWrap firefox)
    (kitty)
    (picom)
    # (nixGLWrap teams)
    (vlc)
    (wezterm)
    (calibre)
    (steam)
    rofi
    yazi
    zathura
    zotero
  ];

  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".fonts.conf".text = ''
    <alias>
    <family>Development</family>

    <!-- Use this font for characters which exist in it. -->
    <prefer><family>Berkeley Mono</family></prefer>

    <!-- Use this font if a character isn't found in the above font. -->
    <accept><family>Symbols Nerd Font Mono</family></accept>
    </alias>
    '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/spenser/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    CALIBRE_USE_DARK_PALETTE = "1";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
      };
    };

    eza = {
      enable = true;
      icons = true;
      extraOptions = ["--group-directories-first"];
      enableAliases = true;
    };

    rofi = {
      enable = true;
      theme = "gruvbox-dark-soft";
      font = "Berkeley Mono 12";
      extraConfig = {
        sidebar-mode = true;
        sorting-method  = "fzf";
        terminal = "alacritty";
      };
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [ ];
    };

    starship = {
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
          format =  "[@](dimmed red)[$hostname](bold green) ";
          trim_at = ".companyname.com";
          disabled = false;
        };

        directory = {
          truncation_length = 8;
        };

        # Disable annoying features
        cmd_duration = { disabled = true; };
        python = { disabled = true; };
        julia = { disabled = true; };
        conda = { disabled = true; };
        vlang = { disabled = true; };
        nodejs = { disabled = true; };
      };
    };

    bottom = {
      enable = true;
      settings = {
        flags = { color = "gruvbox"; };
      };
    };

    broot = {
      enable = true;
      settings = {
        verbs = [
          { invocation = "edit"; key = "F2"; shortcut = "e"; execution = "$EDITOR {file}"; }
          { key = "ctrl-p"; execution = ":line_up"; }
          { key = "ctrl-n"; execution = ":line_down"; }
          { key = "ctrl-u"; execution = ":page_up"; }
          { key = "ctrl-d"; execution = ":page_down"; }
          { invocation = "git_add"; shortcut = "ga"; key = "ctrl-a"; leave_broot = false; execution = "git add {file}"; apply_to = "file"; }
        ];
      };
    };

    tmux = {
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

    fish = {
      enable = true;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "z"; src = pkgs.fishPlugins.z.src; }
      ];
    };

    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;

      # Manage treesitter parsers through nix to avoid issues with libc
      plugins = with pkgs; [
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.vim-plug
      ];
    };

    xmobar = {
      enable = true;
      extraConfig = ''
      Config {
        font = "Berkeley Mono Regular 14",
        additionalFonts = ["Symbols Nerd Font Mono 14", "Fira Mono 14"],
        bgColor = "#1d2021",
        fgColor = "#a89984",
        position = TopH 25,
        lowerOnStart = True,
        commands = [
            Run Cpu ["-L","3","-H","50", "-l", "#b8bb26", "--normal","#458588","--high","#fb4934","-p","3"] 10,
            Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#fb4934","-l","#b8bb26","-n","#458588", "-p","3"] 10,
            Run Swap ["-t","Swap: <usedratio>%","-H","1024","-L","512","-h","#fb4934","-l","#b8bb26","-n","#458588", "-p","3"] 10,
            Run DynNetwork ["-H","200","-L","10","-h","#fb4934","-l","#b8bb26","-n","#458588","-m","4"] 10,
            Run Date "%b %_d %H:%M" "date" 10,

            Run Battery [ "--template" , "Batt: <acstatus>"
                        , "--Low"      , "10"        -- units: %
                        , "--High"     , "80"        -- units: %
                        , "--low"      , "#fb4934"
                        , "--normal"   , "#b8bb26"
                        , "--high"     , "#458588"
                        , "--" -- battery specific options
                        -- discharging status
                        , "-o", "<left>% (<timeleft>)"
                        -- AC "on" status
                        , "-O", "<fc=#dAA520>Charging</fc>"
                        -- charged status
                        , "-i", "<fc=#006000>Charged</fc>"
                        ] 50,

        template = "%StdinReader% }{ <fc=#b16286>[</fc>%cpu%<fc=#b16286>]·[</fc>%memory%<fc=#b16286>]·[</fc>%battery%<fc=#b16286>]·[</fc>%dynnetwork%<fc=#b16286>]·[</fc>%date%<fc=#b16286>]</fc>"
      }
      '';
    };

    alacritty = {
      enable = true;
      package = pkgs.alacritty;
      settings = {
        font = {
          size = 8;
          normal = {
            family = "Development";
            style = "Regular";
          };
          bold = {
            family = "Development";
            style = "Bold";
          };
          italic = {
            family = "Development";
            style = "Italic";
          };
          bold_italic = {
            family = "Development";
            style = "Bold Italic";
          };
        };

        draw_bold_text_with_bright_colors = false;

        colors.primary = {
          background = "0x1d2021";
          foreground = "0xebdbb2";
        };

        colors.normal = {
          black   = "0x282828";
          red     = "0xcc241d";
          green   = "0x98971a";
          yellow  = "0xd79921";
          blue    = "0x458588";
          magenta = "0xb16286";
          cyan    = "0x689d6a";
          white   = "0xa89984";
        };

        colors.bright = {
          black   = "0x928374";
          red     = "0xfb4934";
          green   = "0xb8bb26";
          yellow  = "0xfabd2f";
          blue    = "0x83a598";
          magenta = "0xd3869b";
          cyan    = "0x8ec07c";
          white   = "0xebdbb2";
        };
      };
    };
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
