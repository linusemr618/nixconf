{...}: {
  flake.modules.nixos.minimal = {
    config,
    pkgs,
    ...
  }: {
    programs.zsh.enable = true;
    users.users.${config.var.user.name}.shell = pkgs.zsh;
  };

  flake.modules.homeManager.minimal = {config, ...}: {
    programs = {
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableVteIntegration = true;
        historySubstringSearch = {
          enable = true;
          searchDownKey = "$terminfo[kcud1]";
          searchUpKey = "$terminfo[kcuu1]";
        };
        syntaxHighlighting.enable = true;
        #zsh-abbr.enable = true;
        #zprof.enable = true;

        history = {
          append = true;
          expireDuplicatesFirst = true;
          extended = true;
          findNoDups = true;
          ignoreAllDups = true;
          saveNoDups = true;
        };

        oh-my-zsh = {
          enable = true;
          #theme = "agnoster";
          plugins = [
            "colored-man-pages"
            "extract"
            "git"
            "sudo"
          ];
        };

        shellAliases = {
          gu = "git pull && git add . && git commit -m \"update $(date -u --iso-8601=seconds)\" && git push";
          nu = "nix flake update --flake ${config.var.flake.location}";
          nos = "nh os switch"; # git -C ${config.var.flake.location} add . &&
          nc = "nh clean all";
          update = "nu && nos";
        };

        initContent = ''
          run() { NIXPKGS_ALLOW_UNFREE=1 nix run --impure "nixpkgs#$1" -- "''${@:2}"; }
          run-pr() { NIXPKGS_ALLOW_UNFREE=1 nix run --impure "github:NixOS/nixpkgs/pull/$1/head#$2" -- "''${@:3}"; }
          shell() { NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#"''${^@}; }
          shell-pr() {
            local pr=$1; shift
            NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "github:NixOS/nixpkgs/pull/$pr/head#"''${^@}
          }
        '';
      };
    };
  };
}
