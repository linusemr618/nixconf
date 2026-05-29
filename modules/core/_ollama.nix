{
  flake.nixosModules.core = {
    services = {
      ollama = {
        enable = true;
        loadModels = ["gemma4:e2b"];
      };
      open-webui.enable = true;
    };
  };
}
