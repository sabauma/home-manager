{
  pkgs,
  specialArgs,
  config,
  ...
}:

let
  inherit (specialArgs)
    neovim-nightly
    nixgl
    nix-gl-host
    user-config
    ;

in

{
  nixpkgs.overlays = [
    neovim-nightly.overlays.default
  ];

  imports = [
    ./programs
    ./fonts

    ./neovim.nix
    ./xmonad/xmonad.nix
  ];

  # Configure nixgl
  targets.genericLinux.nixGL.packages = nixgl.packages;

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

  home.sessionVariables = {
    BROWSER = "librewolf";

    GTK_THEME = "Adwaita:dark";

    XDG_CURRENT_DESKTOP = "ubuntu:GNOME";

    # Improved input handling
    MOZ_USE_XINPUT2 = "1";
  };

  xdg = {
    enable = true;

    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];

      # Register librewolf as the default handler for web related files
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
      "x-scheme-handler/chrome" = [ "librewolf.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "application/x-extension-htm" = [ "librewolf.desktop" ];
      "application/x-extension-html" = [ "librewolf.desktop" ];
      "application/x-extension-shtml" = [ "librewolf.desktop" ];
      "application/xhtml+xml" = [ "librewolf.desktop" ];
      "application/x-extension-xhtml" = [ "librewolf.desktop" ];
      "application/x-extension-xht" = [ "librewolf.desktop" ];
    };

    configFile = {
      "clangd/config.yaml".text = builtins.readFile ./clangd-config.yaml;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      (import ./scripts { inherit pkgs; })

      nix-gl-host.defaultPackage.x86_64-linux

      # Useful command line tools
      awscli2
      bat
      bazel-watcher
      bfs
      bottom
      broot
      btop
      claude-code
      cmake
      coder
      coreutils
      datamash
      delta
      diff-so-fancy
      difftastic
      dust
      eza
      fd
      ffmpeg
      htop
      hyperfine
      light
      magic-wormhole
      moreutils
      mosh
      pipx
      ranger
      ripgrep
      shellcheck
      starship
      tmux
      ueberzugpp
      vim-full
      xclip
      xmobar
      yazi

      # Preferred shell
      fish
    ]
    ++ (
      if user-config.graphical then
        map config.lib.nixGL.wrap [
          # Graphical programs
          blueman
          discord
          gnome-control-center
          obsidian
          signal-desktop
          slack
          thunderbird
          vlc
          wezterm
          zathura
          zoom-us
        ]
      else
        [ ]
    );

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 12;
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
    atuin = {
      enable = true;
      # Daemon does not work well on remote dev machines
      daemon.enable = false;
      settings = {
        inline_height = 0;
        style = "full";
        sync.records = true;
      };
    };

    bash = {
      enable = true;

      initExtra = ''
        export PATH=~/.local/bin:$PATH
      '';
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

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
      extraOptions = [ "--group-directories-first" ];
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    fzf = {
      enable = false;
      enableFishIntegration = false;
      enableBashIntegration = false;

      defaultOptions = [ ];
    };

    lazyworktree = {
      enable = true;
      settings = {
        theme = "gruvbox-dark";
      };
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
      font = "Fira Mono 12";
      extraConfig = {
        sidebar-mode = true;
        sorting-method = "fzf";
        terminal = "alacritty";
      };
    };

    television = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;

      settings = {
        ui.theme = "gruvbox-dark";
      };
    };
  };

  services.blueman-applet.enable = true;

  services.picom = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.picom);
    backend = "glx";
    fade = false;
    vSync = true;
  };

  services.ollama = {
    enable = true;
  };

  services.notify-osd.enable = true;
  services.ssh-agent.enable = true;

  services.home-manager.autoExpire = {
    enable = true;
    frequency = "daily";
    timestamp = "-14 days";
    store.cleanup = true;
    store.options = "--delete-older-than 14d";
  };

  xsession = {
    enable = true;
    scriptPath = ".xsessionrc";

    initExtra = ''
      ${pkgs.feh}/bin/feh --bg-fill ${./wallpapers/occ384clcjg51.jpg}
      ${pkgs.setxkbmap}/bin/setxkbmap -option caps:escape
      gnome-screensaver&
    '';
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/desktop/interface".gtk-theme = "Adwaita";
    settings."org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
