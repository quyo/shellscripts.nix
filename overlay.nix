version: final: prev:

let

  mkShellscriptDerivation = src: buildInputs:
    final.stdenv.mkDerivation ({
      pname = baseNameOf src;
      inherit version;
      inherit src;

      nativeBuildInputs = [ final.makeWrapper ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp * $out/bin/

        for file in $out/bin/* ; do
          wrapProgram $file \
            --prefix PATH : $out/bin:${final.lib.makeBinPath (builtins.attrValues buildInputs)}
        done

        runHook postInstall
      '';

      doInstallCheck = true;
      installCheckPhase = ''
        runHook preInstallCheck

        for file in $out/bin/* ; do
          ${final.stdenv.shellDryRun} "$file"
          ${final.shellcheck}/bin/shellcheck "$file"
        done

        runHook postInstallCheck
      '';
    });

in with final; {

  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix findutils git jq nix openssh; };
  dockersh = mkShellscriptDerivation ./docker.sh { inherit docker git nix openssh; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils git gnugrep nix nix-tree openssh; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit git nix openssh rlwrap; };

}
