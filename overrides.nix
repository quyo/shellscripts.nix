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
    cborg = dontCheckHaskell (hprev.cborg.overrideAttrs (oldAttrs: {
      p296 = ./overrides-cborg-p296.patch;
      postPatch = oldAttrs.postPatch or "" + ''
        patch -p2 <$p296
      '';
    }));
    half = dontCheckHaskell hprev.half;
    inline-c = dontCheckHaskell hprev.inline-c;
    inline-c-cpp = dontCheckHaskell hprev.inline-c-cpp;
    insert-ordered-containers = dontCheckHaskell hprev.insert-ordered-containers;
    relude = dontCheckHaskell hprev.relude;
    serialise = dontCheckHaskell hprev.serialise;
    th-orphans = dontCheckHaskell hprev.th-orphans;
    time-compat = dontCheckHaskell hprev.time-compat;
  });

  openssh = dontCheck prev.openssh;
}
