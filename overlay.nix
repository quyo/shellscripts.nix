version: final: prev:

let

  mkShellscriptDerivation = src: extraBuildInputs:
    final.stdenv.mkDerivation ({
      pname = baseNameOf src;
      inherit version;
      inherit src;
      buildInputs = [ final.bash ] ++ (builtins.attrValues extraBuildInputs);
      patchPhase = "for file in * ; do substituteAllInPlace \"$file\" ; done";
      installPhase = "mkdir -p $out/bin && cp * $out/bin/";

      doInstallCheck = true;
      installCheckPhase = ''
        for file in $out/bin/* ; do
          ${final.stdenv.shellDryRun} "$file"
          ${final.shellcheck}/bin/shellcheck "$file"
        done
      '';
    }
    //
    extraBuildInputs);

  # substituteAllInPlace doesn't work on @nix-tree@
  nixtree = final.nix-tree;

in with final; {

  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix findutils git jq nix openssh; };
  dockersh = mkShellscriptDerivation ./docker.sh { inherit docker git nix; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils git gnugrep nix nixtree; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit git nix openssh rlwrap; };

}
