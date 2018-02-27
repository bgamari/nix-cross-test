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
      inherit (self) coreutils iproute procps curl
        bashInteractive runit openssh openssl pcre2
        diffutils ethtool file gawk gnupatch gnugrep pv
        time htop strace netcat libusb eject watch
        mmc-utils nettools sysfsutils iw asciidoc
        sysstat libyaml nfs-utils gcc vim wget rsync
        squashfsTools xz gnutar gzip gnumake which
        nixUnstable python3 gdb autoconf automake
        less nano procps-ng tmux i2c-tools cryptsetup
        git ruby bridge-utils;
    };

    # Minimal git; namely omit tcl/tk and perl
    git = super.git.override { guiSupport = false; perlSupport = false; };

    # guile 2.2 doesn't cross compile. See https://debbugs.gnu.org/cgi/bugreport.cgi?bug=28920
    guile = super.guile_2_0;

    # We really don't need libapparmor and it is a pain to cross compile due to
    # its perl bindings
    systemd = super.systemd.override { libapparmor = null; };

    # From no-x-libs.nix: only needed until proper crossSystem support for nixos
    # is available.
    dbus = super.dbus.override { x11Support = false; };
    pinentry = super.pinentry_ncurses;
  };
in this
