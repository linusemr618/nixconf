{
  # inputs, ...}: {
  # flake.modules.nixos.desktop = {...}: {
  #   nixpkgs.overlays = [inputs.nix4vscode.overlays.default];
  # };

  flake.modules.homeManager.desktop = {pkgs, ...}: let
    package = "vscode";
    #autostartEntry = "code.desktop";
  in {
    programs.${package} = {
      enable = true;
      profiles.default = {
        enableExtensionUpdateCheck = false;
        enableUpdateCheck = false;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          mkhl.direnv
          tomoki1207.pdf
          ms-vscode.cpptools-extension-pack
          ms-vscode.cpptools
          github.copilot-chat
        ];
        /*
            ++ pkgs.nix4vscode.forVscodeVersion pkgs.${package}.version [
            "datakurre.devenv"

            "ms-vscode.cpptools-themes"
            "ms-vscode.cpp-devtools"
            "ms-vscode.cmake-tools"
          ]
        ++ pkgs.nix4vscode.forVscode [
        "github.copilot-chat.0.40.1"
        ];
        */
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

    #xdg.autostart.entries = ["${pkgs.${package}}/share/applications/${autostartEntry}"];
  };
}
