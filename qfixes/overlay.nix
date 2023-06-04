self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (final.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages ignoreKnownVulnerabilities;
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  { }
