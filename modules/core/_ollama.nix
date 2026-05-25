{
  flake.nixosModules.core = {
    services = {
      ollama = {
        enable = true;
        #package = pkgs.ollama-vulkan;
        loadModels = ["gemma4:e2b"];
      };
      open-webui.enable = true;
    };
  };
}
