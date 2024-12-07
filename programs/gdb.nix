{ pkgs, config, ... }:
{
  home.packages = [ pkgs.gdb ];

  xdg.configFile = {
    "gdb/gdbinit".text = ''
      shell mkdir -p -m 0700 ${config.xdg.cacheHome}/gdb

      set history filename ${config.xdg.cacheHome}/gdb/history
      set history save on
      set history size unlimited
    '';
  };

}
