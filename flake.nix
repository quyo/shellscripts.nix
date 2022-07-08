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

      in {

        packages = with pkgs; {
          inherit cachixsh nixbuildsh nixsh;
        };

        devShell = with pkgs.devshell; mkShell {
          imports = [ (importTOML ./devshell.toml) ];
        };

      }
    );

}
