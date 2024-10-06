{
  pkgs,
  config,
  specialArgs,
  ...
}:

let
  inherit (specialArgs)
    mlir-nix
    neovim-nightly
    nixgl
    git-fuzzy
    user-config
    ;

  nixGLWrap = import ./nixGLWrap.nix { inherit pkgs; };
in

{
  nixpkgs.overlays = [
    mlir-nix.overlays.default
    neovim-nightly.overlays.default

    # Needed for nixGLWrap to work properly
    nixgl.overlay
  ];

  imports = [
    ./alacritty.nix
    ./fonts/default.nix
    ./firefox.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./xmonad/xmonad.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = user-config.username;
  home.homeDirectory = "/home/${user-config.username}";

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

  xdg.configFile = {
    "gdb/gdbinit".text = ''
      shell mkdir -p -m 0700 ${config.xdg.cacheHome}/gdb

      set history filename ${config.xdg.cacheHome}/gdb/history
      set history save on
      set history size unlimited
    '';
  };

  home.sessionVariables = {
    BROWSER = "firefox-beta";

    GTK_THEME = "Adwaita:dark";

    XDG_CURRENT_DESKTOP = "ubuntu:GNOME";
  };

  xdg = {
    enable = true;

    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];

      # Register firefox-beta as the default handler for web related files
      "x-scheme-handler/http" = [ "firefox-beta.desktop" ];
      "x-scheme-handler/https" = [ "firefox-beta.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox-beta.desktop" ];
      "text/html" = [ "firefox-beta.desktop" ];
      "application/x-extension-htm" = [ "firefox-beta.desktop" ];
      "application/x-extension-html" = [ "firefox-beta.desktop" ];
      "application/x-extension-shtml" = [ "firefox-beta.desktop" ];
      "application/xhtml+xml" = [ "firefox-beta.desktop" ];
      "application/x-extension-xhtml" = [ "firefox-beta.desktop" ];
      "application/x-extension-xht" = [ "firefox-beta.desktop" ];
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # From github:sabauma/mlir-nix
    # Since the mlir build includes clang, it can conflict with other
    # packages which install clang. Set as lowPrio to avoid shadowing an
    # official build of clang.
    # (pkgs.lowPrio mlir)

    (import ./scripts { inherit pkgs; })
    (import ./git-fuzzy.nix { inherit pkgs git-fuzzy; })

    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "DroidSansMono" ]; })

    # Language Servers
    bash-language-server
    cmake-language-server
    lua-language-server
    nil
    pyright
    ruff

    # Useful command line tools
    awscli2
    bat
    bottom
    broot
    cmake
    coreutils
    datamash
    diff-so-fancy
    du-dust
    eza
    fd
    ffmpeg
    fzf
    gh
    git-absorb
    git-lfs
    git
    htop
    hyperfine
    light
    mosh
    ranger
    ripgrep
    shellcheck
    starship
    tmux
    ueberzugpp
    vim_configurable
    xclip
    xmobar
    yazi

    ccache
    llvmPackages_19.clang-tools

    # Preferred shell
    fish

    # Graphical programs
    (nixGLWrap kitty)
    flameshot
    obsidian
    rofi
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 12;
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

    bash = {
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
        flags = {
          color = "gruvbox";
        };
      };
    };

    broot = {
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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = true;
      extraOptions = [ "--group-directories-first" ];
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      plugins = [
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "z";
          src = pkgs.fishPlugins.z.src;
        }
      ];

      functions = {
        fish_greeting = "";

        fish_key_bindings = "fish_vi_key_bindings";

        fish_user_key_bindings = ''
          fish_vi_key_bindings

          for mode in insert default visual
              bind -M $mode \cf forward-char
          end
        '';
      };

      interactiveShellInit = ''
        fish_add_path ~/.modular/bin
      '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [ ];
    };

    lazygit = {
      enable = true;
    };

    readline = {
      enable = true;
      extraConfig = ''
        set editing-mode vi
      '';
    };

    rofi = {
      enable = true;
      theme = "gruvbox-dark-hard";
      font = "Berkeley Mono 12";
      extraConfig = {
        sidebar-mode = true;
        sorting-method = "fzf";
        terminal = "alacritty";
      };
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

  services.blueman-applet.enable = true;

  services.picom = {
    enable = true;
    package = (nixGLWrap pkgs.picom);
    backend = "glx";
    fade = false;
    vSync = true;
  };

  services.notify-osd.enable = true;
  services.ssh-agent.enable = true;

  xsession = {
    enable = true;
    scriptPath = ".xsessionrc";

    initExtra = ''
      ${pkgs.feh}/bin/feh --bg-fill ${./wallpapers/occ384clcjg51.jpg}
      ${pkgs.xorg.setxkbmap}/bin/setxkbmap -option caps:escape
      gnome-screensaver&
    '';
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/interface".gtk-theme = "Adwaita";
    settings."org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape"];
    };
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
