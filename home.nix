{
  pkgs,
  config,
  specialArgs,
  ...
}:

let
  inherit (specialArgs)
    neovim-nightly
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
    BROWSER = "librewolf";

    GTK_THEME = "Adwaita:dark";

    XDG_CURRENT_DESKTOP = "ubuntu:GNOME";
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
  home.packages = with pkgs; [
    (import ./scripts { inherit pkgs; })

    # Useful command line tools
    awscli2
    bat
    betterlockscreen
    bfs
    bitwarden-cli
    bottom
    broot
    btop-cuda
    claude-code
    coder
    coreutils
    delta
    diff-so-fancy
    difftastic
    dust
    eza
    fd
    ffmpeg
    htop
    hyperfine
    magic-wormhole
    mosh
    openconnect
    ranger
    ripgrep
    vim-full
    xclip
    yt-dlp

    # Gnome tools
    gnome-screenshot

    # Preferred shell
    fish

    # Graphical programs
    bitwarden-desktop
    calibre
    chromium
    discord-canary
    grayjay
    kitty
    libreoffice
    obsidian
    picom
    remmina
    rofi
    signal-desktop
    slack
    steam
    thunderbird
    vlc
    wezterm
    yazi
    zathura
    zoom-us
    zotero
  ];

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
      daemon.enable = true;
      settings = {
        inline_height = 0;
        style = "full";
        sync.records = true;
      };
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

    readline = {
      enable = true;
      extraConfig = ''
        set editing-mode vi
      '';
    };

    rofi = {
      enable = true;
      theme = "gruvbox-dark-hard";
      font = "Berkeley Mono 14";
      extraConfig = {
        sidebar-mode = true;
        sorting-method = "fzf";
        terminal = "alacritty";
      };
    };

    television = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      settings = {
        ui.theme = "gruvbox-dark";
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    fade = false;
    vSync = true;
  };

  services.ollama = {
    enable = false;
    acceleration = "cuda";
  };

  services.flameshot.enable = true;
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

    initExtra = ''
      nvidia-settings --assign CurrentMetaMode="DP-0: nvidia-auto-select +2160+840, HDMI-0: nvidia-auto-select +0+0 {rotation=left}"

      ${pkgs.feh}/bin/feh --bg-fill ${./wallpapers/occ384clcjg51.jpg}
      ${pkgs.xorg.xset}/bin/xset dpms 3600 3600 3600
      ${pkgs.xorg.xset}/bin/xset s off
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
