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

  # substituteAllInPlace doesn't work on @nix-tree@
  nixtree = final.nix-tree;

in with final; {

  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix findutils jq nix; };
  dockersh = mkShellscriptDerivation ./docker.sh { inherit docker nix; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils gnugrep nix nixtree; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit nix openssh rlwrap; };

}
