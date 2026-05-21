{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes ca-derivations";
  nativeBuildInputs = with pkgs; [
    age
    git
    sops
    ssh-to-age
  ];
}
