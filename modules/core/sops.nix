{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.core = {...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile = self + "/secrets.yaml";
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };

  flake.homeModules.core = {pkgs, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];
    sops = {
      defaultSopsFile = self + "/secrets.yaml";
      age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    };
  };
}
