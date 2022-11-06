self: final: prev:

let
  qnixpkgs = "github:Samayel/qnixpkgs/${self.inputs.qnixpkgs.rev}";
  version = final.lib.q.flake.version self;

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

      preferLocalBuild = true;

      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin
        cp * $out/bin/

        for file in $out/bin/* ; do
          wrapProgram $file \
            --prefix PATH : $out/bin:${makeBinPath (attrValues deps)} \
            --set QNIXPKGS ${qnixpkgs}
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
in

with final; {

  cachixsh = mkShellscriptDerivation ./cachix.sh ({ inherit findutils git jq nix openssh; }
    // lib.optionalAttrs (stdenv.hostPlatform.isAarch32 == false) { inherit cachix; });
  dockersh = mkShellscriptDerivation ./docker.sh { inherit coreutils git nix openssh; };
  matrixsh = mkShellscriptDerivation ./matrix.sh { inherit coreutils gnused httpie less; };
  miscsh = mkShellscriptDerivation ./misc.sh { inherit httpie less; };
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils git gnugrep jq nix nix-tree openssh symlinks; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit git nix openssh rlwrap; };
  projectsh = mkShellscriptDerivation ./project.sh { inherit coreutils direnv git nix openssh; };
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
        projectsh
        quyosh
      ];
    };

}
