{
  bashInteractive,
  cachixsh,
  dockerTools,
  dockersh,
  matrixsh,
  miscsh,
  nixbuildsh,
  nixsh,
  qshell-minimal,
  quyosh
}:

let

  contents = [
    qshell-minimal

    cachixsh
    dockersh
    matrixsh
    miscsh
    nixbuildsh
    nixsh
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
