{ lib, ... }:

let
  # Every `<name>.md` in ./skills becomes the skill `<name>`
  # (installed as `~/.config/opencode/skills/<name>/SKILL.md`).
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
  programs.opencode = {
    enable = true;

    inherit skills;

    settings = {
      lsp = true;

      provider = {
        modular = {
          npm = "@ai-sdk/openai-compatible";
          name = "Modular";
          options = {
            baseURL = "https://api.modular.com/v1";
          };

          models = {
            "deepseek/deepseek-v4.1-flash-1017" = {
              name = "DeepSeek V4.1 Flash";
            };
            "zai-org/glm-5.3" = {
              name = "GLM 5.3";
            };
            "z-ai/glm-5.2" = {
              name = "GLM 5.2";
            };
            "minimax/minimax-m3" = {
              name = "Minimax m3";
            };
            "moonshotai/kimi-k2.7-code" = {
              name = "Kimi 2.7 Code";
            };
            "google/gemma-4-31b-it" = {
              name = "Gemma 4 31b";
            };
            "google/gemma-4-26b-a4b-it" = {
              name = "Gemma 4 26b";
            };
          };
        };
      };
    };

    cli = {
      theme = {
        name = "gruvbox";
      };
    };
  };
}
