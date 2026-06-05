{
  flake.modules.nixos.core = {...}: {
    services = {
      ollama = {
        enable = true;
        #host = "0.0.0.0";
        loadModels = ["gemma4:e2b"];
        #openFirewall = true;
      };
      open-webui = {
        enable = true;
        port = 11111;
      };
    };
  };
}
