self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages ignoreKnownVulnerabilities;
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
    libgit2 = dontCheck prev.libgit2;

    pixman = prev.pixman.overrideAttrs (oldAttrs: {
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
        "-Darm-simd=disabled"
        "-Dneon=disabled"
      ];
    });
  }
