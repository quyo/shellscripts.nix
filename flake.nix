{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    let
      version = builtins.substring 0 8 self.lastModifiedDate;
    in
    {
      overlays = {
        default = import ./overlay.nix version;
      };
    }
    //
    flake-utils.lib.eachSystem [ flake-utils.lib.system.x86_64-linux ] (system:
      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = (builtins.attrValues self.overlays) ++ [
            devshell.overlay
          ];
        };

        flakePkgs = {
          inherit (pkgs)
            cachixsh
            nixbuildsh
            nixsh;
        };

      in {

        packages = flakePkgs
          //
          {
            default = pkgs.linkFarmFromDrvs "shellscripts-packages-all" (map (x: flakePkgs.${x}) (builtins.attrNames flakePkgs));
          };

        apps = import ./apps.nix self system;

        devShells = {
          default = with pkgs.devshell; mkShell {
            imports = [ (importTOML ./devshell.toml) ];
          };
        };

      }
    );

}
