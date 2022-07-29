{ bashInteractive
, dockerTools
, qshell-minimal
, shellscripts
}:

let
  contents = [
    qshell-minimal
    shellscripts
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
