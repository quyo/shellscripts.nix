{ cachixsh
, dockersh
, matrixsh
, miscsh
, nixsh
, nixbuildsh
, projectsh
, quyosh
, resticsh
}:

let
  apps = {
    cachix-push-flake-inputs = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-inputs"; };
    cachix-push-flake-runtime-closures-all = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-runtime-closures-all"; };
    cachix-push-flake-runtime-closure-single = { type = "app"; program = "${cachixsh}/bin/cachix-push-flake-runtime-closure-single"; };
    cachix-watch-exec = { type = "app"; program = "${cachixsh}/bin/cachix-watch-exec"; };
    cachix-watch-store = { type = "app"; program = "${cachixsh}/bin/cachix-watch-store"; };

    docker-cleanup = { type = "app"; program = "${dockersh}/bin/docker-cleanup"; };
    docker-load-nix-build = { type = "app"; program = "${dockersh}/bin/docker-load-nix-build"; };
    docker-memory-top10 = { type = "app"; program = "${dockersh}/bin/docker-memory-top10"; };
    docker-pull-n-up = { type = "app"; program = "${dockersh}/bin/docker-pull-n-up"; };
    docker-tag-n-push = { type = "app"; program = "${dockersh}/bin/docker-tag-n-push"; };

    matrix-ansible-check = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-check"; };
    matrix-ansible-fix-media-store = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-fix-media-store"; };
    matrix-ansible-maintenance-postgres-vacuum = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-maintenance-postgres-vacuum"; };
    matrix-ansible-registration-multitoken = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-registration-multitoken"; };
    matrix-ansible-registration-singletoken = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-registration-singletoken"; };
    matrix-ansible-update = { type = "app"; program = "${matrixsh}/bin/matrix-ansible-update"; };
    matrix-api-cli = { type = "app"; program = "${matrixsh}/bin/matrix-api-cli"; };
    matrix-api-script = { type = "app"; program = "${matrixsh}/bin/matrix-api-script"; };
    matrix-postgres-mjolnir-reset-watchedlists = { type = "app"; program = "${matrixsh}/bin/matrix-postgres-mjolnir-reset-watchedlists"; };
    matrix-postgres-relation-stats = { type = "app"; program = "${matrixsh}/bin/matrix-postgres-relation-stats"; };

    http-less = { type = "app"; program = "${miscsh}/bin/http-less"; };
    https-less = { type = "app"; program = "${miscsh}/bin/https-less"; };
    simplex-chat = { type = "app"; program = "${miscsh}/bin/simplex-chat"; };

    nix-cache-upload = { type = "app"; program = "${nixsh}/bin/nix-cache-upload"; };
    nix-cache-upload-flake = { type = "app"; program = "${nixsh}/bin/nix-cache-upload-flake"; };
    nix-dependency-graph-at-buildtime = { type = "app"; program = "${nixsh}/bin/nix-dependency-graph-at-buildtime"; };
    nix-dependency-graph-at-runtime = { type = "app"; program = "${nixsh}/bin/nix-dependency-graph-at-runtime"; };
    nix-fake = { type = "app"; program = "${nixsh}/bin/nix-fake"; };
    nix-fakechannel = { type = "app"; program = "${nixsh}/bin/nix-fakechannel"; };
    nix-fakechannel-fakenix = { type = "app"; program = "${nixsh}/bin/nix-fakechannel-fakenix"; };
    nix-info = { type = "app"; program = "${nixsh}/bin/nix-info"; };
    nix-list-packages = { type = "app"; program = "${nixsh}/bin/nix-list-packages"; };
    nix-list-subpackages = { type = "app"; program = "${nixsh}/bin/nix-list-subpackages"; };
    nix-search = { type = "app"; program = "${nixsh}/bin/nix-search"; };
    nix-setup-userscope-cocalc = { type = "app"; program = "${nixsh}/bin/nix-setup-userscope-cocalc"; };
    nix-store-repair = { type = "app"; program = "${nixsh}/bin/nix-store-repair"; };
    nix-system-cleanup = { type = "app"; program = "${nixsh}/bin/nix-system-cleanup"; };
    nix-system-update = { type = "app"; program = "${nixsh}/bin/nix-system-update"; };
    nix-tree-at-buildtime = { type = "app"; program = "${nixsh}/bin/nix-tree-at-buildtime"; };
    nix-tree-at-runtime = { type = "app"; program = "${nixsh}/bin/nix-tree-at-runtime"; };

    nixbuild-remote-store = { type = "app"; program = "${nixbuildsh}/bin/nixbuild-remote-store"; };
    nixbuild-shell = { type = "app"; program = "${nixbuildsh}/bin/nixbuild-shell"; };

    project-init = { type = "app"; program = "${projectsh}/bin/project-init"; };
    project-init-caddy = { type = "app"; program = "${projectsh}/bin/project-init-caddy"; };
    project-init-jupyter = { type = "app"; program = "${projectsh}/bin/project-init-jupyter"; };
    project-init-node-nest = { type = "app"; program = "${projectsh}/bin/project-init-node-nest"; };
    project-setup-fly-app-domain = { type = "app"; program = "${projectsh}/bin/project-setup-fly-app-domain"; };

    quyo-gitpull = { type = "app"; program = "${quyosh}/bin/quyo-gitpull"; };
    quyo-reboot = { type = "app"; program = "${quyosh}/bin/quyo-reboot"; };
    quyo-runall = { type = "app"; program = "${quyosh}/bin/quyo-runall"; };

    restic-backup = { type = "app"; program = "${resticsh}/bin/restic-backup"; };
    restic-backup-automatic-daily = { type = "app"; program = "${resticsh}/bin/restic-backup-automatic-daily"; };
    restic-backup-automatic-hourly = { type = "app"; program = "${resticsh}/bin/restic-backup-automatic-hourly"; };
    restic-exec = { type = "app"; program = "${resticsh}/bin/restic-exec"; };
  };
in

apps

# //
# {
#   default = apps.[...];
# }
