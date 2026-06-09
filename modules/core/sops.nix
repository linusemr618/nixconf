{
  inputs,
  self,
  ...
}: {
  flake.modules.nixos.core = {...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile = self + "/secrets.yaml";
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        #keyFile = "/home/${config.user.name}/.config/sops/age/keys.txt";
      };
    };
  };

  flake.modules.homeManager.core = {pkgs, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
    ];
    sops = {
      defaultSopsFile = self + "/secrets.yaml";
      age = {
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        #keyFile = "/home/${config.user.name}/.config/sops/age/keys.txt";
      };
    };
  };
}
