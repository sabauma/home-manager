{ pkgs, lib, ... }:

let
  # Wrap commands with nixGL to get GPU acceleration
  nixGL = import <nixgl> {};

  # Workaround until the issues with nixGL are fixed:
  # https://github.com/nix-community/nixGL/pull/165
  # nixGL = pkgs.callPackage (pkgs.fetchFromGitHub {
  #   owner  = "nix-community";
  #   repo   = "nixGL";
  #   rev    = "717facdec8104d7435fd6d54e90361b5eae5276d";
  #   sha256 = "sha256-wrjFD3zQMvtwziv/LjQQrO6fmrpa7WRQpnk5dkTvcDo=";
  # }) { inherit pkgs; };

  nixGLWrap = pkg:
  let
    bins = "${pkg}/bin";
  in
  pkgs.buildEnv {
    name = "nixGL-${pkg.name}";
    meta = pkg.meta;
    passthru = {
      inherit (pkg) version;
    };
    paths =
      [ pkg ] ++
      (map
        (bin: pkgs.hiPrio (
          pkgs.writeShellScriptBin bin ''
            exec -a "$0" "${nixGL.auto.nixGLDefault}/bin/nixGL" "${bins}/${bin}" "$@"
          ''
        ))
        (builtins.attrNames (builtins.readDir bins)));
  };

in
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  imports = [ ./neovim.nix ];

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
    (builtins.getFlake "github:sabauma/mlir.nix").packages.${pkgs.system}.mlir

    # (import ./pkgs/cgir-mlir-manager.nix { inherit pkgs; })
    (import ./pkgs/logline.nix { inherit pkgs; })
    (import ./pkgs/netron.nix { inherit pkgs; })

    nerdfonts

    # Useful command line tools
    bat
    bitwarden-cli
    bottom
    broot
    coreutils
    datamash
    delta
    du-dust
    eza
    fd
    ffmpeg
    fzf
    #gdb
    gitFull
    htop
    hyperfine
    mosh
    newsboat
    nil
    ninja
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

    # Gnome tools
    gnome.gnome-screenshot

    ccache
    clang-tools_18

    # Preferred shell
    fish

    # Graphical programs
    (nixGLWrap alacritty)
    (nixGLWrap chromium)
    (nixGLWrap firefox-beta)
    (nixGLWrap kitty)
    (nixGLWrap obsidian)
    (nixGLWrap picom)
    (nixGLWrap remmina)
    (nixGLWrap thunderbird)
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

    # Xsession configuration
    ".xsessionrc".source = ./xsessionrc;
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
    alacritty = {
      enable = true;
      package = (nixGLWrap pkgs.alacritty);
      settings = {
        font = {
          size = 11;
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

        colors.draw_bold_text_with_bright_colors = false;

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

        shell.program = "${pkgs.fish}/bin/fish";
      };
    };

    atuin = {
      enable = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = true;
      extraOptions = ["--group-directories-first"];
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];

      interactiveShellInit = ''
      source /mathworks/inside/labs/dev/matlab_coder_tools/sbtools-completions/sbtools-completions/fish/setup.fish
      '';

      functions = {
        # Configure the user keybindings to use vim
        fish_user_key_bindings = ''
          bind -M insert \cf accept-autosuggestion
          for mode in insert default visual
              bind -M $mode \cf forward-char
          end
        '';

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
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [ ];
    };

    rofi = {
      enable = true;
      theme = "gruvbox-dark-hard";
      font = "Berkeley Mono 14";
      extraConfig = {
        sidebar-mode = true;
        sorting-method  = "fzf";
        terminal = "alacritty";
      };
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
      secureSocket = false;
      shell = "${pkgs.fish}/bin/fish";

      plugins = with pkgs.tmuxPlugins; [
        gruvbox
        prefix-highlight
        tmux-fzf
      ];

      extraConfig = ''
      set -as terminal-overrides ",*:Tc"

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

    xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };
  };

  services.picom = {
    enable = true;
    package = (nixGLWrap pkgs.picom);
    backend = "glx";
    fade = false;
  };

  services.flameshot.enable = true;
  services.notify-osd.enable = true;
  services.ssh-agent.enable = true;

  xsession = {
    enable = true;

    initExtra = ''
    ${pkgs.feh}/bin/feh --bg-fill ${./wallpapers/occ384clcjg51.jpg}
    '';
  };

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = ps: with ps; [
      hashable
      text-icu
      vector
      xmobar
      xmonad
      xmonad-contrib
      xmonad-extras
    ];

    config = ./xmonad/xmonad.hs;
    libFiles = {
      "FindEmptyWorkspace.hs" = ./xmonad/lib/FindEmptyWorkspace.hs;
      "Gruvbox.hs" = ./xmonad/lib/Gruvbox.hs;
      "PerWorkspaceDirs.hs" = ./xmonad/lib/PerWorkspaceDirs.hs;
      "PromptConfig.hs" = ./xmonad/lib/PromptConfig.hs;
    };
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
