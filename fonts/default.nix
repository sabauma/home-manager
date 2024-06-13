{ pkgs, ... }:

{
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

    # Link in the fonts directories with personal fonts
    ".fonts/".source = ./.;
    ".local/share/fonts".source = ./.;
  };
}
