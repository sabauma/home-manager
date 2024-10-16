{ pkgs, ... }:
{
  programs.fish = {
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
}
