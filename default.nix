let 
    callPackage = set: f: overrides: f ((builtins.intersectAttrs (builtins.functionArgs f) set) // overrides);
in
(import ./reflex-platform { }).project ({ pkgs, ... }: {
    packages = {
        common = ./common;
        backend = ./backend;
        frontend = ./frontend;
    };
    overrides = self: super: {
      beam-core = callPackage ./packages/beam-core.nix { };
      beam-migrate = callPackage ./packages/beam-migrate.nix { };
      beam-postgres = callPackage ./packages/beam-postgres.nix { };
    };

    shells = {
        ghc = ["common" "backend" "frontend"];
        ghcjs = ["common" "frontend"];
    };
})
