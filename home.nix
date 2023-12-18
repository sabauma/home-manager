{ config, pkgs, lib, ... }:

let
  # Wrap commands with nixGL to get GPU acceleration
  nixGL = import <nixgl> {};
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
      wrapped_bin=$out/bin/$(basename $bin)
      echo "exec ${lib.getExe nixGL.auto.nixGLDefault} $bin \$@" > $wrapped_bin
      chmod +x $wrapped_bin
    done
  '';
in
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
  home.username = "sbauman";
  home.homeDirectory = "/home/sbauman";

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
    delta
    eza
    fd
    ffmpeg
    fzf
    gitFull
    htop
    hyperfine
    mosh
    neovim-nightly
    newsboat
    openconnect
    pyright
    python3Packages.python-lsp-server
    ranger
    ripgrep
    starship
    tmux
    vim_configurable
    xmobar
    yt-dlp
    yazi

    ccache
    clang-tools_17

    # Preferred shell
    fish

    # Graphical programs
    (nixGLWrap alacritty)
    (nixGLWrap chromium)
    (nixGLWrap latest.firefox-beta-bin)
    (nixGLWrap kitty)
    (nixGLWrap picom)
    (nixGLWrap vlc)
    (nixGLWrap wezterm)
    rofi
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
    # Define a fonts.conf file with a 'Development' font family which uses the
    # preferred Berkeley Mono font while having a fallback font for Symbols not
    # present in Berkeley Mono.
    ".fonts.conf".text = ''
    <alias>
    <family>Development</family>

    <!-- Use this font for characters which exist in it. -->
    <prefer><family>Berkeley Mono</family></prefer>

    <!-- Use this font if a character isn't found in the above font. -->
    <accept><family>Fira Mono Nerd Font</family></accept>
    </alias>
    '';

    # Link in the fonts directory with personal fonts
    ".fonts/".source = ./fonts;

    "Pictures/wallpapers/".source = ./wallpapers;
  };

  fonts.fontconfig.enable = true;

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
      font = "Berkeley Mono 16";
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
      ];

    functions = {
      bac-clone = "mw -using Bmain sbs create -c $argv[1] -bac";

      change = "p4 change (changes) $argv";

      changes = ''
      p4 opened -s | grep -o '\<[0-9][0-9]*\>' | sort --unique --numeric-sort --reverse |
      fzf --preview 'p4 describe {} | bat --color=always --pager=never --decorations=never --language=COMMIT_EDITMSG' \
          --preview-window=70%:wrap:rounded --cycle --phony --exit-0
      '';

      mktags = ''
      fd --extension "hpp" --extension "cpp" \
         --extension "c" --extension "h" \
         --extension "cc" --extension "hh" \
      | ctags --sort=foldcase --c++-kinds=+p --fields=+iaS --extra=+q -f ./tags -L- &;
      '';

      net-sandbox = ''
      set -l cluster $argv[1]
      set -l tag $argv[2]
      set -l output (mktemp)

      if test "$tag" = ""
        mw -using $cluster sbs create -c $cluster | tee "$output"
      else
        mw -using $cluster sbs create -c $cluster -t $tag | tee "$output"
      end

      set -l dir (grep -o '/mathworks/devel/sbs/.*$' "$output")
      rm "$output"

      cd "$dir""/matlab/src"
      mktags
      '';

      s = "cd (sandboxes) $argv";

      sandboxes = ''
      mw -using Bmain sbs list |
        tail -n +3 |
        awk '{print $3};' |
        sort |
        fzf --multi --preview "summarize-sandbox {}" --preview-window=up:70%:wrap:rounded --tac --cycle --exit-0 |
        awk '{print $1}'
      '';
    };

    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;

      extraConfig = builtins.readFile ./nvim/init.vim;
      extraLuaConfig = builtins.readFile ./nvim/config.lua;

      # Manage treesitter parsers through nix to avoid issues with libc
      plugins = with pkgs.vimPlugins; [
        # Vim Plugins
        a-vim
        nerdcommenter
        tabular
        undotree
        vim-fugitive
        vim-indent-object
        vim-obsession
        vim-repeat
        vim-surround
        vim-vinegar

        # Treesitter
        nvim-treesitter.withAllGrammars

        # Colorschemes
        gruvbox-material
        everforest

        # Neovim-notify
        nvim-notify

        # nvim-cmp
        nvim-cmp
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-path

        # LSP
        nvim-lspconfig
        lspkind-nvim

        # Lualine
        lualine-nvim

        # Telescope
        telescope-nvim
        telescope-fzf-native-nvim

        # Neorg
        neorg
        neorg-telescope
        zen-mode-nvim

        # Nice popup messages
        popup-nvim

        # Oil file manager
        oil-nvim
      ];
    };

    xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };

    alacritty = {
      enable = true;
      package = (nixGLWrap pkgs.alacritty);
      settings = {
        font = {
          size = 16;
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
