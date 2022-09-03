self: final: prev:

let
  inherit (prev) lib stdenv;

  dontCheck = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  dontCheckHaskell = prev.haskell.lib.dontCheck;
in

{
}
// lib.optionalAttrs stdenv.hostPlatform.isAarch32
{
  aws-c-common = dontCheck prev.aws-c-common;

  haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
    bsb-http-chunked = dontCheckHaskell hprev.bsb-http-chunked;
    half = dontCheckHaskell hprev.half;
    relude = dontCheckHaskell hprev.relude;
    th-orphans = dontCheckHaskell hprev.th-orphans;
    time-compat = dontCheckHaskell hprev.time-compat;
  });

  openssh = dontCheck prev.openssh;
}
