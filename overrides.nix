self: final: prev:

let
  inherit (prev) lib stdenv;
  inherit (prev.lib.q) dontCheck dontInstallCheck dontCheckHaskell fixllvmPackages;
in

{ }
  // lib.optionalAttrs stdenv.hostPlatform.isAarch32
  { }
