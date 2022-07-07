self: super:

let
  mkShellscriptDerivation = with super; src: extraBuildInputs: patchPhase:
    stdenv.mkDerivation {
      name = baseNameOf src;
      inherit src;
      buildInputs = [ bash ] ++ extraBuildInputs;
      inherit patchPhase;
      installPhase = "mkdir -p $out/bin && cp * $out/bin/";
    };
in

{
  # this key should be the same as the flake name attribute.
  shellscripts-flake = with super; {

    nixsh = mkShellscriptDerivation ./nix.sh [] "";

    cachixsh = mkShellscriptDerivation ./cachix.sh [ cachix jq ] ''
      sed -i -e "s|cachix |${cachix}/bin/cachix |g" cachix-*
      sed -i -e "s|jq |${jq}/bin/jq |g"             cachix-*
    '';

    nixbuildsh = mkShellscriptDerivation ./nixbuild.sh [ rlwrap ] ''
      sed -i -e "s|rlwrap |${rlwrap}/bin/rlwrap |g" nixbuild-*
    '';

  };
}
