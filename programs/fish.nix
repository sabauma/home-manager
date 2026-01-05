{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];

    # Not a fan of the default shell bindings for tv.
    # Configure it to use the same bindings as fzf.
    interactiveShellInit = ''
      bind -M insert \ct tv_smart_autocomplete
      bind -M insert \cr tv_shell_history
      bind -M visual \ct tv_smart_autocomplete
      bind -M visual \cr tv_shell_history
    '';

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
  };
}
