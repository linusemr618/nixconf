{...}: {
  flake.modules.nixos.minimal = {...}: {
    services = {
      ollama = {
        enable = true;
        #host = "0.0.0.0";
        loadModels = ["gemma4:e2b" "qwen2.5-coder:0.5b"];
        #openFirewall = true;
      };
      open-webui = {
        enable = true;
        port = 11111;
      };
    };
  };
}
