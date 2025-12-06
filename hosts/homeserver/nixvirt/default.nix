{
  config,
  inputs,
  pkgs,
  lib,
  options,
  ...
}:

{
  #imports = [ inputs.nixvirt.nixosModules.default ];
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "kvm_amd"
      "vendor-reset"
    ];

    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "vfio-pci.ids=1002:1638,1002:1637"
      "usbcore.autosuspend=-1"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      vendor-reset
    ];

    blacklistedKernelModules = [ "amdgpu" ];
  };
  virtualisation.libvirt = {
    enable = true;
    verbose = true;
    swtpm.enable = true;
    connections."qemu:///system" = {
      domains = [
        {
          definition = "/dpool/data/batocera/batocera.xml";
        }
      ];
    };
  };
}
