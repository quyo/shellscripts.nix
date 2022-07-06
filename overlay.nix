self: super:

let
  mkShellscriptDerivation = with super; src:
    stdenv.mkDerivation {
      name = baseNameOf src;
      inherit src;
      buildInputs = [ bash ];
      installPhase = "mkdir -p $out/bin && cp * $out/bin/";
    };
in

{
  # this key should be the same as the flake name attribute.
  shellscripts-flake = {
    nix.sh = mkShellscriptDerivation ./nix.sh;
    cachix.sh = mkShellscriptDerivation ./cachix.sh;
  };
}
