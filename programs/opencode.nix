{ ... }:
{
  programs.opencode = {
    enable = true;

    settings = {
      provider = {
        modular = {
          npm = "@ai-sdk/openai-compatible";
          name = "Modular";
          options = {
            baseURL = "https://api.modular.com/v1";
          };

          models = {
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

    tui = {
      theme = "gruvbox";
    };
  };
}
