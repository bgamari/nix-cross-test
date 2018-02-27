# Usage: nix-build ./nixos.nix -A system

let
  pkgs = import ./default.nix {};
  config_module = {config, lib, pkgs, ... }: {
    environment.systemPackages = [
      pkgs.parted
      pkgs.ddrescue
      pkgs.usbutils
      pkgs.unzip
      pkgs.zip
    ];
    boot.supportedFilesystems = [ "vfat" ];
  };

  nixos = import ./nixpkgs/nixos {
    configuration = {
      nixpkgs.pkgs = pkgs;

      imports = [ config_module ];

      fonts.fontconfig.enable = false;
      security.polkit.enable = false;
      security.rngd.enable = false;
      environment.noXlibs = true;
      system.autoUpgrade.enable = false;
      services.udisks2.enable = false;
      services.nixosManual.enable = false;
      services.bind.enable = false;

      #nixpkgs.overlays = [ (import ./overlay) ];
      nixpkgs.config.allowBroken = true;

      fileSystems."/".device = "/dev/mmcblk0p2";

      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux;
      boot.kernelParams = [];

      # FIXME: this probably should be in installation-device.nix
      users.extraUsers.root.initialHashedPassword = "";
    };
  };

in
  nixos
