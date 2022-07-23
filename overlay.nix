version: final: prev:

let

  mkShellscriptDerivation =
    let
      inherit (builtins) attrValues;
      inherit (final) lib makeWrapper shellcheck stdenv;
    in
      src: buildInputs: stdenv.mkDerivation ({
        pname = baseNameOf src;
        inherit version;
        inherit src;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp * $out/bin/

          for file in $out/bin/* ; do
            wrapProgram $file \
              --prefix PATH : $out/bin:${lib.makeBinPath (attrValues buildInputs)}
          done

          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck

          for file in $out/bin/* ; do
            ${stdenv.shellDryRun} "$file"
            ${shellcheck}/bin/shellcheck "$file"
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
