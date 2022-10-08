self: final: prev:

let
  inherit (prev) lib stdenv;

  dontCheck = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
  });

  dontInstallCheck = drv: drv.overrideAttrs (oldAttrs: {
    doInstallCheck = false;
  });

  dontCheckHaskell = prev.haskell.lib.dontCheck;

  dontCheckLLVM = drv: drv.overrideAttrs (oldAttrs: {
    doCheck = false;
    cmakeFlags = map (x: builtins.replaceStrings ["DLLVM_BUILD_TESTS=ON"] ["DLLVM_BUILD_TESTS=OFF"] x) oldAttrs.cmakeFlags;
  });

  fixllvmPackages = llvmPkgs: llvmPkgs // (
    let
      tools = llvmPkgs.tools.extend (tfinal: tprev: {
        libllvm = dontCheckLLVM tprev.libllvm;
      });
    in
    { inherit tools; } // tools
  );
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
    cryptonite = dontCheckHaskell hprev.cryptonite;
    half = dontCheckHaskell hprev.half;
    inline-c = dontCheckHaskell hprev.inline-c;
    inline-c-cpp = dontCheckHaskell hprev.inline-c-cpp;
    insert-ordered-containers = dontCheckHaskell hprev.insert-ordered-containers;
    lukko = dontCheckHaskell hprev.lukko;
    relude = dontCheckHaskell hprev.relude;
    serialise = dontCheckHaskell hprev.serialise;
    th-orphans = dontCheckHaskell hprev.th-orphans;
    time-compat = dontCheckHaskell hprev.time-compat;
  });

  llvmPackages = fixllvmPackages prev.llvmPackages;
  llvmPackages_12 = fixllvmPackages prev.llvmPackages_12;
  llvmPackages_13 = fixllvmPackages prev.llvmPackages_13;
  llvmPackages_14 = fixllvmPackages prev.llvmPackages_14;
  llvmPackages_latest = fixllvmPackages prev.llvmPackages_latest;

  openssh = dontCheck prev.openssh;

  python310 = prev.python310 // {
    pkgs = prev.python310.pkgs.overrideScope (pyfinal: pyprev: {
      sh = dontInstallCheck pyprev.sh;
    });
  };
}
