{ dockerTools, qshell-minimal, cachixsh, dockersh, nixsh, nixbuildsh, bashInteractive }:

let

  contents = [
    qshell-minimal

    cachixsh
    dockersh
    nixsh
    nixbuildsh
  ];

in

dockerTools.buildLayeredImage {
  name = "quyo/shellscripts.nix";
  tag = "latest";

  inherit contents;

  config = {
    Cmd = [ "${bashInteractive}/bin/bash" ];
  };
}
