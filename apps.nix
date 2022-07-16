pkgs:

let

  apps = with pkgs; {
    cachix-push-flake-inputs                 = { type = "app"; program = "${pkgs.cachixsh}/bin/cachix-push-flake-inputs"; };
    cachix-push-flake-runtime-closures-all   = { type = "app"; program = "${pkgs.cachixsh}/bin/cachix-push-flake-runtime-closures-all"; };
    cachix-push-flake-runtime-closure-single = { type = "app"; program = "${pkgs.cachixsh}/bin/cachix-push-flake-runtime-closure-single"; };
    cachix-watch-exec                        = { type = "app"; program = "${pkgs.cachixsh}/bin/cachix-watch-exec"; };
    cachix-watch-store                       = { type = "app"; program = "${pkgs.cachixsh}/bin/cachix-watch-store"; };

    nix-cache-upload                         = { type = "app"; program = "${pkgs.nixsh}/bin/nix-cache-upload"; };
    nix-cache-upload-flake                   = { type = "app"; program = "${pkgs.nixsh}/bin/nix-cache-upload-flake"; };
    nix-system-cleanup                       = { type = "app"; program = "${pkgs.nixsh}/bin/nix-system-cleanup"; };
    nix-system-update                        = { type = "app"; program = "${pkgs.nixsh}/bin/nix-system-update"; };

    nixbuild-remote-store                    = { type = "app"; program = "${pkgs.nixbuildsh}/bin/nixbuild-remote-store"; };
    nixbuild-shell                           = { type = "app"; program = "${pkgs.nixbuildsh}/bin/nixbuild-shell"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
