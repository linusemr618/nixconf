{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.minimal = {lib, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile =
        if (builtins.getEnv "EMPTY_SECRETS") == "1"
        then self + "/secrets/empty.yaml"
        else self + "/secrets/secrets.yaml";
      age = {
        sshKeyPaths = lib.mkIf (builtins.getEnv "EMPTY_SECRETS" != 1) ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = lib.mkIf (builtins.getEnv "EMPTY_SECRETS" == "1") "${builtins.getEnv "PWD"}/secrets/empty.txt";
      };
    };
  };

  flake.modules.homeManager.minimal = {
    lib,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];
    sops = {
      defaultSopsFile =
        if (builtins.getEnv "EMPTY_SECRETS") == "1"
        then self + "/secrets/empty.yaml"
        else self + "/secrets/secrets.yaml";
      age = {
        sshKeyPaths = lib.mkIf (builtins.getEnv "EMPTY_SECRETS" != 1) ["/etc/ssh/ssh_host_ed25519_key"];
        keyFile = lib.mkIf (builtins.getEnv "EMPTY_SECRETS" == "1") "${builtins.getEnv "PWD"}/secrets/empty.txt";
      };
    };
  };
}
