version: final: prev:

let

  mkShellscriptDerivation = src: deps:
    let
      inherit (builtins) attrValues;
      inherit (final) lib makeWrapper shellcheck stdenvNoCC;
      inherit (lib) makeBinPath;
      inherit (stdenvNoCC) shellDryRun;
    in
      stdenvNoCC.mkDerivation ({
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
              --prefix PATH : $out/bin:${makeBinPath (attrValues deps)}
          done

          runHook postInstall
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          runHook preInstallCheck

          for file in $out/bin/* ; do
            ${shellDryRun} "$file"
            ${shellcheck}/bin/shellcheck "$file"
          done

          runHook postInstallCheck
        '';
      });

in with final; {

  cachixsh = mkShellscriptDerivation ./cachix.sh { inherit cachix findutils git jq nix openssh; };
  dockersh = mkShellscriptDerivation ./docker.sh { inherit coreutils git nix openssh; };
  matrixsh = mkShellscriptDerivation ./matrix.sh { inherit coreutils gnused httpie less; };
  miscsh = mkShellscriptDerivation ./misc.sh { inherit httpie less; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils git gnugrep jq nix nix-tree openssh; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit git nix openssh rlwrap; };
  quyosh = mkShellscriptDerivation ./quyo.sh { inherit coreutils openssh; };

  shellscripts = buildEnv
  {
    name = "shellscripts-${version}";
    paths = [
      cachixsh
      dockersh
      matrixsh
      miscsh
      nixsh
      nixbuildsh
      quyosh
    ];
  };

}
