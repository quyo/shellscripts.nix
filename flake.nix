{
  # nixConfig.extra-substituters = "https://quyo-public.cachix.org ssh://eu.nixbuild.net?priority=90";
  # nixConfig.extra-trusted-public-keys = "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0= nixbuild.net/quyo-1:TaAsUc6SBQnXhUQJM4s+1oQlTKa1e3M0u3Zqb36fbRc=";

  inputs = {
    # nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.05";
    nixpkgs-stable.url = "github:nixos/nixpkgs/9ecc270f02b09b2f6a76b98488554dd842797357";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/95fda953f6db2e9496d2682c4fc7b82f959878f7";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    qnixpkgs.url = "github:Samayel/qnixpkgs";
    qnixpkgs.inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    qnixpkgs.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    qnixpkgs.inputs.flake-utils.follows = "flake-utils";
    qnixpkgs.inputs.devshell.follows = "devshell";
    qnixpkgs.inputs.flake-compat.follows = "flake-compat";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils, devshell, qnixpkgs, ... }:
    {
      overlays = {
        default = import ./overlay.nix self;
        overrides = import ./overrides.nix self;
      };
    }
    //
    flake-utils.lib.eachSystem (map (x: flake-utils.lib.system.${x}) [ "x86_64-linux" "armv7l-linux" ]) (system:
      let
        inherit (pkgs-stable) lib;

        version = lib.q.flake.version self;

        overlays = (builtins.attrValues self.overlays) ++ [
          devshell.overlay
          qnixpkgs.overlays.qfixes
          qnixpkgs.overlays.qlib
          qnixpkgs.overlays.qshell
        ];

        pkgs-stable = import nixpkgs-stable { inherit overlays system; };
        pkgs-unstable = import nixpkgs-unstable { inherit overlays system; };

        flake-pkgs-stable-mapper = lib.q.mapPkgs
          [
            "cachixsh"
            "jupytersh"
            "matrixsh"
            "miscsh"
            "nixbuildsh"
            "projectsh"
            "quyosh"
            "shellscripts"
          ];

        flake-pkgs-unstable-mapper = lib.q.mapPkgs
          [
            "dockersh"
            "nixsh"
          ];

        flake-pkgs =
          flake-pkgs-stable-mapper pkgs-stable "" ""
          //
          flake-pkgs-unstable-mapper pkgs-unstable "" "";
      in
      {
        packages = lib.q.flake.packages "shellscripts" version flake-pkgs { } ./docker.nix;

        apps = lib.q.flake.apps flake-pkgs ./apps.nix;

        devShells = lib.q.flake.devShells ./devshell.toml;

        formatter = lib.q.flake.formatter;
      }
    );
}
