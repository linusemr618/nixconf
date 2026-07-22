{...}: {
  flake.modules.nixos.minimal = {config, ...}: {
    virtualisation = {
      docker.rootless = {
        enable = true;
        setSocketVariable = true;
      };
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };
      spiceUSBRedirection.enable = true;
    };
    users.users.${config.var.user.name}.extraGroups = ["libvirtd"];
  };
}
