{ pkgs, lib, ... }:

let
  # Read all files in the fonts directory
  fontFiles = builtins.readDir ./.;

  # Filter for .ttf and .otf files only
  isFontFile =
    name: type: type == "regular" && (lib.hasSuffix ".ttf" name || lib.hasSuffix ".otf" name);

  # Create home.file entries for each font file
  mkFontLinks =
    basePath:
    lib.mapAttrs' (
      name: type:
      lib.nameValuePair "${basePath}/${name}" {
        source = ./. + "/${name}";
      }
    ) (lib.filterAttrs isFontFile fontFiles);
in
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
      <accept><family>Symbols Nerd Font</family></accept>
      </alias>
    '';
  }
  # Link individual font files to .fonts/
  // mkFontLinks ".fonts"
  # Also link to .local/share/fonts
  // mkFontLinks ".local/share/fonts";

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
