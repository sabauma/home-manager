{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

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
      <accept><family>Fira Code</family></accept>
      </alias>
    '';

    # Link in the fonts directories with personal fonts
    ".fonts/".source = ./.;
    ".local/share/fonts".source = ./.;
  };

  home.packages = with pkgs.nerd-fonts; [
    fira-code
    fira-mono
    hasklug
    inconsolata
    iosevka
    jetbrains-mono
    monoid
    sauce-code-pro
    symbols-only
    ubuntu
    ubuntu-mono
    victor-mono
    zed-mono
  ];
}
