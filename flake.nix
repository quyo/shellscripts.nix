{
  # nixConfig.extra-substituters = "https://quyo-public.cachix.org ssh://eu.nixbuild.net?priority=90";
  # nixConfig.extra-trusted-public-keys = "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0= nixbuild.net/quyo-1:TaAsUc6SBQnXhUQJM4s+1oQlTKa1e3M0u3Zqb36fbRc=";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.11";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/9ecc270f02b09b2f6a76b98488554dd842797357";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/95fda953f6db2e9496d2682c4fc7b82f959878f7";

    flake-utils.url = "github:numtide/flake-utils";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs-stable";
    devshell.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    qnixpkgs.url = "github:quyo/qnixpkgs";
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
        inherit (pkgs-stable) buildEnv lib q;

        version = lib.q.flake.version self;

        overlays = (builtins.attrValues self.overlays) ++ [
          devshell.overlay
          qnixpkgs.overlays.qfixes
          qnixpkgs.overlays.qlib
          qnixpkgs.overlays.qshell
        ];

        importChannel = { name, path, overlays }:
          let
            home = builtins.getEnv "HOME";
            dir = /${home}/.nix-defexpr/channels/${path};
            sources = import /${dir}/nix/sources.nix;
            channel = sources.${name};
            overlay = (import /${dir}/overlay.nix) { inherit sources; };
          in
            import channel { overlays = [ overlay ] ++ overlays; };

        importChannel2211 = { overlays }: importChannel { inherit overlays; name = "nixpkgs-22.11"; path = "nixpkgs-stable-22_11"; };
        importChannelUnstable = { overlays }: importChannel { inherit overlays; name = "nixpkgs-unstable"; path = "nixpkgs-unstable"; };

        pkgs-stable = importChannel2211 { inherit overlays; };
        pkgs-unstable = importChannelUnstable { inherit overlays; };

        flake-pkgs-stable-mapper = lib.q.mapPkgs
          [
            "cachixsh"
            "dockersh"
            "matrixsh"
            "miscsh"
            "nixsh"
            "nixbuildsh"
            "projectsh"
            "quyosh"
            "resticsh"
          ];

        flake-pkgs-unstable-mapper = lib.q.mapPkgs
          [
          ];

        flake-pkgs =
          flake-pkgs-stable-mapper pkgs-stable "" ""
          //
          flake-pkgs-unstable-mapper pkgs-unstable "" "";

        flake-pkgs-with-bundle =
          flake-pkgs
          //
          {
            shellscripts = q.shellscripts.buildFullEnv flake-pkgs;
          };
      in
      {
        packages = lib.q.flake.packages "shellscripts" version flake-pkgs-with-bundle { } ./docker.nix;

        apps = lib.q.flake.apps flake-pkgs-with-bundle ./apps.nix;

        devShells = lib.q.flake.devShells ./devshell.toml;

        formatter = lib.q.flake.formatter;
      }
    );
}
