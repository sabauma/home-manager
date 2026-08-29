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
            "z-ai/glm-5.2" = {
              name = "GLM 5.2";
            };
            "zai-org/glm-5.3" = {
              name = "GLM 5.3";
            };
            "minimax/minimax-m3" = {
              name = "Minimax m3";
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
