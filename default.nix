# Usage: nix-build ./nixos.nix -A system

let
  config_module = {config, lib, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      perlXMLParser
      haskellPackages.heaps
    ];
    nixpkgs.crossSystem = {
      config = "armv7l-unknown-linux-gnueabihf";
      arch = "armv7l";
      float = "hard";
      fpu = "vfpv3-d16";
      withTLS = true;
      openssl.system = "linux-armv4";
      platform = pkgs.platforms.armv7l-hf-multiplatform // {
        kernelBaseConfig = "xilinx_zynq_defconfig";
        kernelTarget = "uImage";
        kernelMakeFlags = [ "LOADADDR=0x0200000" ];
        uboot = pkgs.ubootMicrozed;
      };
    };

    boot.loader.grub.enable = false;
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux;
    boot.kernelParams = [];
    boot.supportedFilesystems = [ "vfat" ];
  };

  nixos = import ./nixpkgs/nixos {
    configuration = {
      imports = [ config_module ];

      fonts.fontconfig.enable = false;
      security.polkit.enable = false;
      security.rngd.enable = false;
      system.autoUpgrade.enable = false;
      services.udisks2.enable = false;
      services.nixosManual.enable = false;
      services.bind.enable = false;

      #nixpkgs.overlays = [ (import ./overlay) ];
      nixpkgs.config.allowBroken = true;

      fileSystems."/".device = "/dev/mmcblk0p2";

      # FIXME: this probably should be in installation-device.nix
      users.extraUsers.root.initialHashedPassword = "";
    };
  };

in
  nixos
