{
  flake.modules.nixos.core = {pkgs, ...}: {
    programs.fish.enable = true;
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };

  flake.modules.homeManager.core = {
    config,
    pkgs,
    ...
  }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting # Disable greeting
      '';
      plugins =
        map (plugin: {
          name = plugin;
          src = pkgs.fishPlugins.${plugin}.src;
        }) [
          "fzf-fish"
          "forgit"
          "done"
          "hydro"
          "grc"
          #"colored-man-pages"
          "z"
        ];
      functions = {
        gu = "git pull && git add . && git commit -m \"update $(date -u --iso-8601=seconds)\" && git push";
        nu = "nix flake update --flake ${config.flake.location}";
        nos = "pushd ${config.flake.location} && git add . && nh os switch && popd";
        nc = "nh clean all";
        run = "NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$argv[1] -- $argv[2..-1]";
        shell = "NIXPKGS_ALLOW_UNFREE=1 nix shell --impure (string replace -r '^' 'nixpkgs#' $argv) -c fish";
        update = "nu && nos";
      };
    };

    home.packages = with pkgs; [
      bat
      fd
      fzf
      grc
    ];
  };
}
