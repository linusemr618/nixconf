{...}: {
  flake.modules.nixos.graphical = {config, ...}: {
    virtualisation.vmware.host = {
      enable = true;
      extraConfig = ''
        # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
        mks.gl.allowUnsupportedDrivers = "TRUE"
        mks.vk.allowUnsupportedDevices = "TRUE"
      '';
    };
    users.users.${config.var.user.name}.extraGroups = ["vmware"];
  };
}
