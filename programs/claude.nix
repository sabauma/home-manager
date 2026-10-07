{ lib, ... }:

let
  # Every `<name>.md` in ./skills becomes the skill `<name>`
  # (installed as `~/.claude/skills/<name>/SKILL.md`).
  skillsDir = ./skills;
  skills =
    lib.mapAttrs' (file: _: lib.nameValuePair (lib.removeSuffix ".md" file) (skillsDir + "/${file}"))
      (
        lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".md" file) (
          builtins.readDir skillsDir
        )
      );
in
{
  home.sessionVariables = {
    # Enable teams
    CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS = "1";
  };

  programs.claude-code = {
    enable = true;

    inherit skills;
  };
}
