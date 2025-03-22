self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages ignoreKnownVulnerabilities;
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
      time-compat = dontCheckHaskell hprev.time-compat;
    });

    libgit2 = dontCheck prev.libgit2;

    pixman = prev.pixman.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
        "-Darm-simd=disabled"
        "-Dneon=disabled"
      ];
    });
  }
