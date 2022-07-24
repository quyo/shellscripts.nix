{
  bashInteractive,
  cachixsh,
  dockerTools,
  dockersh,
  nixbuildsh,
  nixsh,
  qshell-minimal
}:

let

  contents = [
    qshell-minimal

    cachixsh
    dockersh
    matrixsh
    miscsh
    nixsh
    nixbuildsh
    quyosh
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
