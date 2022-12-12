self: final: prev:

let
  qnixpkgs = "github:quyo/qnixpkgs/${self.inputs.qnixpkgs.rev}";
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
  matrixsh = mkShellscriptDerivation ./matrix.sh ({ inherit coreutils gnused less; }
    // lib.optionalAttrs (stdenv.hostPlatform.isAarch32 == false) { inherit httpie; });
  miscsh = mkShellscriptDerivation ./misc.sh ({ inherit git less nix openssh restic; }
    // lib.optionalAttrs (stdenv.hostPlatform.isAarch32 == false) { inherit httpie; });
  nixsh = mkShellscriptDerivation ./nix.sh { inherit coreutils findutils git gnugrep jq nix nix-tree openssh symlinks; };
  nixbuildsh = mkShellscriptDerivation ./nixbuild.sh { inherit git nix openssh rlwrap; };
  projectsh = mkShellscriptDerivation ./project.sh { inherit coreutils direnv git nix openssh; };
  quyosh = mkShellscriptDerivation ./quyo.sh { inherit coreutils openssh; };
  resticsh = mkShellscriptDerivation ./restic.sh { inherit restic; };

  q = (prev.q or { })
    //
    {
      shellscripts = rec {
        buildStableEnv = pkgs: buildEnv
          {
            name = "shellscripts-stable-${version}";
            paths = with pkgs; [
              cachixsh
              dockersh
              matrixsh
              miscsh
              nixsh
              nixbuildsh
              projectsh
              quyosh
              resticsh
            ];
          };

        buildUnstableEnv = pkgs: buildEnv
          {
            name = "shellscripts-unstable-${version}";
            paths = with pkgs; [
            ];
          };

        buildFullEnv = pkgs: buildEnv
          {
            name = "shellscripts-${version}";
            paths = [
              (buildStableEnv pkgs)
              (buildUnstableEnv pkgs)
            ];
          };
      };
    };
}
