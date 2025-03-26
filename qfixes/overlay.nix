self: final: prev:

let
  inherit (prev) fetchpatch lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;

  stablePkgs = import self.inputs.nixpkgs-stable {
    system = stdenv.hostPlatform.system;
  };
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  {
  }
