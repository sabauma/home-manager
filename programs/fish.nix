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
      fish_user_key_bindings = ''
        for mode in insert default visual
            bind -M $mode \cf forward-char
        end
      '';
    };
  };
}
