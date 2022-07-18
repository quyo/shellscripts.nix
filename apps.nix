{ cachixsh, dockersh, nixsh, nixbuildsh }:

let

  apps = {
    cachix-push-flake-inputs                 = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-inputs"; };
    cachix-push-flake-runtime-closures-all   = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-runtime-closures-all"; };
    cachix-push-flake-runtime-closure-single = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-runtime-closure-single"; };
    cachix-watch-exec                        = { type = "app"; program = "${cachixsh}/bin/cachix-watch-exec"; };
    cachix-watch-store                       = { type = "app"; program = "${cachixsh}/bin/cachix-watch-store"; };

    docker-load-nix-build                    = { type = "app"; program = "${dockersh}/bin/docker-load-nix-build"; };

    nix-cache-upload                         = { type = "app"; program = "${nixsh}/bin/nix-cache-upload"; };
    nix-cache-upload-flake                   = { type = "app"; program = "${nixsh}/bin/nix-cache-upload-flake"; };
    nix-dependency-graph-at-build-time       = { type = "app"; program = "${nixsh}/bin/nix-dependency-graph-at-build-time"; };
    nix-dependency-graph-at-runtime          = { type = "app"; program = "${nixsh}/bin/nix-dependency-graph-at-runtime"; };
    nix-system-cleanup                       = { type = "app"; program = "${nixsh}/bin/nix-system-cleanup"; };
    nix-system-update                        = { type = "app"; program = "${nixsh}/bin/nix-system-update"; };
    nix-tree-at-build-time                   = { type = "app"; program = "${nixsh}/bin/nix-tree-at-build-time"; };
    nix-tree-at-runtime                      = { type = "app"; program = "${nixsh}/bin/nix-tree-at-runtime"; };

    nixbuild-remote-store                    = { type = "app"; program = "${nixbuildsh}/bin/nixbuild-remote-store"; };
    nixbuild-shell                           = { type = "app"; program = "${nixbuildsh}/bin/nixbuild-shell"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
