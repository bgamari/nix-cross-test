{nix ? (import ./nixpkgs)}:

let
  nixpkgs = nix {};
  crossSystem = nixpkgs.lib.systems.examples.armv7l-hf-multiplatform // {
    config = "armv7l-unknown-linux-gnueabihf";
    #arch = "armv7-a";
    #libc = "glibc";
    withTLS = true;
    openssl.system = "linux-armv4";
    platform = nixpkgsCross.pkgs.platforms.armv7l-hf-multiplatform // {
      kernelBaseConfig = "defconfig";
    };
  };

nixpkgsCross = nix {
  overlays = [(import ./overlay.nix)];
  crossSystem = crossSystem;
#  config = { defaultLd = "gold"; };
};
in nixpkgsCross
