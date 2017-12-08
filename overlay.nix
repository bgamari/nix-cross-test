self: super:

let
  pkgs = self.pkgs;
  buildPackages = pkgs.buildPackages;
  callPackage = self.pkgs.callPackage;
  evalConfig = modules: self.lib.evalModules {
    modules = modules;
    #system = super.stdenv.hostPlatform.system;
  };

  this = rec {

  knownGoodCrossed = {
    inherit (super) coreutils iproute procps curl
      bashInteractive runit openssh openssl pcre2
      diffutils ethtool file gawk gnupatch gnugrep pv
      time htop strace netcat libusb eject watch
      mmc-utils nettools sysfsutils iw asciidoc #bridge-utils
      sysstat libyaml nfs-utils gcc
      ;
    # cryptsetup
    # bridge-utils
    # nfs-utils
    # iotop: python dep
    # emacs
    # wget: ruby dependency
    # wpa_supplicant
    # sudo
    # gcc
    # systemd: Due to libapparmor
  };

  # guile 2.2 doesn't cross compile. See https://debbugs.gnu.org/cgi/bugreport.cgi?bug=28920
  guile = super.guile_2_0;

  # We really don't need libapparmor and it is a pain to cross compile due to
  # its perl bindings
  systemd = super.systemd.override { libapparmor = null; };
};
in this
