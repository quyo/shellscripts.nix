version: final: prev:

let

  mkShellscriptDerivation = with prev; src: extraBuildInputs:
    stdenv.mkDerivation ({
      pname = baseNameOf src;
      inherit version;
      inherit src;
      buildInputs = [ bash ] ++ (builtins.attrValues extraBuildInputs);
      patchPhase = "for i in * ; do substituteAllInPlace $i ; done";
      installPhase = "mkdir -p $out/bin && cp * $out/bin/";
    }
    //
    extraBuildInputs);

in with prev; {

  nixsh = mkShellscriptDerivation ./nix.sh {};
  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix jq; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit rlwrap; };

}
