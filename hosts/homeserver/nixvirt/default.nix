{ config, inputs, pkgs, lib,... }:

{
  boot.initrd.kernelModules = [ 
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
    "amdgpu"
   ];
  boot.kernelParams = [
    "amd_iommu=on"
    "vfio-pci.ids=1002:1638,1002:1637"
  ];
  
  virtualisation.libvirt.enable = true;
}
