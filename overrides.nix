self: final: prev:

let
  inherit (prev) haskell lib stdenv;

  dontCheck = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  haskellPackagesOverrides = hfinal: hprev: {
    bsb-http-chunked = haskell.lib.dontCheck hprev.bsb-http-chunked;
    half = haskell.lib.dontCheck hprev.half;
    relude = haskell.lib.dontCheck hprev.relude;
    th-orphans = haskell.lib.dontCheck hprev.th-orphans;
    time-compat = haskell.lib.dontCheck hprev.time-compat;
  };
in

{
}
// lib.optionalAttrs stdenv.hostPlatform.isAarch32
{
  aws-c-common = dontCheck prev.aws-c-common;

  haskellPackages = prev.haskellPackages.override {
    overrides = haskellPackagesOverrides;
  } // { overrides = haskellPackagesOverrides; };

  openssh = dontCheck prev.openssh;
}
