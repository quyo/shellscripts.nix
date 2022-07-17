version: final: prev:

let

  mkShellscriptDerivation = src: extraBuildInputs:
    final.stdenv.mkDerivation ({
      pname = baseNameOf src;
      inherit version;
      inherit src;
      buildInputs = [ final.bash ] ++ (builtins.attrValues extraBuildInputs);
      patchPhase = "for i in * ; do substituteAllInPlace $i ; done";
      installPhase = "mkdir -p $out/bin && cp * $out/bin/";
    }
    //
    extraBuildInputs);

in with final.unstable; {

  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix findutils jq nix; };
  dockersh = mkShellscriptDerivation ./docker.sh { inherit docker nix; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit gnugrep nix; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit nix openssh rlwrap; };

}
