{
  pkgs,
  specialArgs,
  ...
}:

let
  inherit (specialArgs)
    mlir-nix
    neovim-nightly
    nixgl
    user-config
    ;

  nixGLWrapOverlay = final: prev: {
    nixGLWrap = import ./nixGLWrap.nix { pkgs = prev; };
  };
in

{
  nixpkgs.overlays = [
    mlir-nix.overlays.default
    neovim-nightly.overlays.default

    # Needed for nixGLWrap to work properly
    nixgl.overlay
    nixGLWrapOverlay
  ];

  imports = [
    ./programs
    ./fonts

    ./neovim.nix
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

    configFile = {
      "clangd/config.yaml".text = builtins.readFile ./clangd-config.yaml;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      # From github:sabauma/mlir-nix
      # Since the mlir build includes clang, it can conflict with other
      # packages which install clang. Set as lowPrio to avoid shadowing an
      # official build of clang.
      # (pkgs.lowPrio mlir)

      (import ./scripts { inherit pkgs; })

      # Useful command line tools
      awscli2
      bat
      bottom
      broot
      cmake
      coder
      coreutils
      datamash
      delta
      diff-so-fancy
      difftastic
      du-dust
      eza
      fd
      ffmpeg
      fzf
      htop
      hyperfine
      light
      mosh
      pipx
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

      # Preferred shell
      fish
    ]
    ++ (
      if user-config.graphical then
        [
          # Graphical programs
          blueman
          obsidian
          rofi
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
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;

      defaultOptions = [ ];
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
      font = "Berkeley Mono Variable 12";
      extraConfig = {
        sidebar-mode = true;
        sorting-method = "fzf";
        terminal = "alacritty";
      };
    };
  };

  services.blueman-applet.enable = true;

  services.picom = {
    enable = true;
    package = (pkgs.nixGLWrap pkgs.picom);
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
      xkb-options = [ "caps:escape" ];
    };
  };

  targets.genericLinux.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
