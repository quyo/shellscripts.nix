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
