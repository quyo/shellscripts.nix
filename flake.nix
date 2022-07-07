{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "shellscripts-flake";
      config = { };
      overlay = ./overlay.nix;
      systems = [ "x86_64-linux" ];
    };

}
