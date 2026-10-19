{...}: {
  flake.modules.nixos.optional = {...}: {
    services = {
      ollama = {
        # enable = true;
        # host = "0.0.0.0";
        loadModels = ["gemma4:e2b" "gemma4:e4b" "qwen3.5:2b" "qwen3.5:4b" "openbmb/minicpm5-2b:2b" "ingloryon/k2-horizon:3.7b"];
        # openFirewall = true;
        # package = pkgs.ollama-vulkan;
        # environmentVariables = {
        #   OLLAMA_IGPU_ENABLE = "1";
        # };
      };
      open-webui = {
        # enable = true;
        port = 11111;
      };
    };
  };
}
