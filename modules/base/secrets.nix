{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.baseSecrets = {...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile = self + "/secrets/secrets.yaml";
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };

  flake.modules.homeManager.baseSecrets = {
    config,
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
      defaultSopsFile = self + "/secrets/secrets.yaml";
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };
  };
}
