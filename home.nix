{ pkgs, specialArgs, ... }:

let
  inherit (specialArgs) mlir-nix neovim-nightly neorg-overlay;
in

{
  nixpkgs.overlays = [
    neovim-nightly.overlays.default
    neorg-overlay.overlays.default
  ];

  imports = [
    ./alacritty.nix
    ./neovim.nix
    ./starship.nix
    ./xmonad/xmonad.nix
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

  home.sessionVariables = {
    BROWSER = "firefox-beta";

    GTK_THEME = "Adwaita:dark";

    XDG_CURRENT_DESKTOP = "ubuntu:GNOME";
  };

  xdg = {
    enable = true;

    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];

      # Register firefox-beta as the default handler for web related files
      "x-scheme-handler/http"=["firefox-beta.desktop"];
      "x-scheme-handler/https"=["firefox-beta.desktop"];
      "x-scheme-handler/chrome"=["firefox-beta.desktop"];
      "text/html"=["firefox-beta.desktop"];
      "application/x-extension-htm"=["firefox-beta.desktop"];
      "application/x-extension-html"=["firefox-beta.desktop"];
      "application/x-extension-shtml"=["firefox-beta.desktop"];
      "application/xhtml+xml"=["firefox-beta.desktop"];
      "application/x-extension-xhtml"=["firefox-beta.desktop"];
      "application/x-extension-xht"=["firefox-beta.desktop"];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # From github:sabauma/mlir-nix
    mlir-nix.packages.${pkgs.system}.default

    nerdfonts

    # Useful command line tools
    bat
    betterlockscreen
    bitwarden-cli
    bottom
    broot
    cmake
    coreutils
    datamash
    du-dust
    eza
    fd
    ffmpeg
    fzf
    git
    htop
    hyperfine
    mosh
    newsboat
    nil
    ninja
    openconnect
    pyright
    ranger
    ripgrep
    starship
    tmux
    vim_configurable
    xclip
    xmobar
    yt-dlp

    # Gnome tools
    gnome.gnome-screenshot

    ccache
    clang-tools_18

    # Preferred shell
    fish

    # Graphical programs
    calibre
    chromium
    discord
    firefox-beta
    kitty
    libreoffice
    obsidian
    picom
    remmina
    rofi
    signal-desktop
    steam
    thunderbird
    vlc
    wezterm
    yazi
    zathura
    zotero
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 12;
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
    ".local/share/fonts".source = ./fonts;
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
        { name = "z"; src = pkgs.fishPlugins.z.src; }
      ];

      functions = {
        fish_user_key_bindings = ''
          for mode in insert default visual
              bind -M $mode \cf forward-char
          end
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

    xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };

    zellij = {
      enable = true;
      settings = {
        default_layout = "compact";
        default_shell = "${pkgs.fish}/bin/fish";
        scrollback_editor = "${pkgs.neovim}/bin/nvim";
        pane_frames = false;

        theme = "gruvbox-dark";
        themes = {
          gruvbox-dark = {
            fg = "#D5C4A1";
            bg = "#282828";
            black = "#3C3836";
            red = "#CC241D";
            green = "#98971A";
            yellow = "#D79921";
            blue = "#3C8588";
            magenta = "#B16286";
            cyan = "#689D6A";
            white = "#FBF1C7";
            orange = "#D65D0E";
          };
        };
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = false;
    vSync = true;
  };

  xsession = {
    enable = true;

    initExtra = ''
    ${pkgs.feh}/bin/feh --bg-fill ${./wallpapers/occ384clcjg51.jpg}
    '';
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/interface".gtk-theme = "Adwaita";
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
