pkgs:

let

  contents = with pkgs; [
    qshell-minimal

    cachixsh
    dockersh
    nixsh
    nixbuildsh
  ];

in

pkgs.dockerTools.buildLayeredImage {
  name = "shellscripts.nix";
  tag = "latest";

  inherit contents;

  config = {
    Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}