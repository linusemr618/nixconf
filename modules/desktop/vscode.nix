{inputs, ...}: {
  flake.nixosModules.desktop = {
    nixpkgs.overlays = [inputs.nix4vscode.overlays.default];
  };

  flake.homeModules.desktop = {pkgs, ...}: {
    programs.vscodium = {
      enable = true;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions =
          pkgs.nix4vscode.forVscodeVersion pkgs.vscodium.version [
            "jnoortheen.nix-ide"
            "mkhl.direnv"
            "tomoki1207.pdf"
            "datakurre.devenv"

            "ms-vscode.cpptools-extension-pack"
            "ms-vscode.cpptools"
            "ms-vscode.cpptools-themes"
            "ms-vscode.cpp-devtools"
            "ms-vscode.cmake-tools"
          ]
          ++ pkgs.nix4vscode.forVscode [
            "github.copilot-chat.0.40.1"
          ];
        userSettings = {
          "chat.disableAIFeatures" = false;
          "files.autoSave" = "onFocusChange";
          "git.confirmSync" = false;
          "git.autofetch" = true;
          "git.enableSmartCommit" = true;
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "alejandra";
          "nix.hiddenLanguageServerErrors" = ["textDocument/definition" "textDocument/formatting"];
          "nix.serverSettings".nixd.formatting.command = ["alejandra"];
        };
      };
    };
    home.packages = with pkgs; [
      alejandra
      nixd
    ];

    #xdg.configFile."autostart/codium.desktop".source = "${pkgs.vscodium}/share/applications/codium.desktop";
  };
}
