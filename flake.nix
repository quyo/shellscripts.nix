{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    {
      overlay = import ./overlay.nix;
    }
    //
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
            devshell.overlay
          ];
        };

      in rec {

        packages = with pkgs; {
          inherit cachixsh nixbuildsh nixsh;
        };

        devShell = pkgs.devshell.mkShell {
          imports = [ (pkgs.devshell.importTOML ./devshell.toml) ];
        };

      }
    );

}
