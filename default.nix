let reflex-platform = builtins.fetchGit {
      url = https://github.com/reflex-frp/reflex-platform.git;
      ref = "develop";
      rev = "a700776dd17a2a2cf3571f35920d3d57730c3ad6";
    };
in (import reflex-platform { }).project ({ pkgs, ... }: {
    packages = {
        common = ./common;
        backend = ./backend;
        frontend = ./frontend;
    };
    overrides = self: super: rec {
      beam-core = self.callPackage ./packages/beam-core.nix { };
      beam-migrate = self.callPackage ./packages/beam-migrate.nix { };
      beam-postgres = self.callPackage ./packages/beam-postgres.nix { };
      servant-reflex = self.callPackage ./packages/servant-reflex.nix { };
      frontend = pkgs.haskell.lib.dontHaddock super.frontend;
      common = pkgs.haskell.lib.dontHaddock super.common;
      backend = pkgs.haskell.lib.overrideCabal super.backend (drv: { enableSharedExecutables = false; });
    };

    shells = {
        ghc = ["common" "backend" "frontend"];
        ghcjs = ["common" "frontend"];
    };

    shellToolOverrides = ghc: super: {
        inherit (ghc) hpack;
        fswatcher = pkgs.inotify-tools;
        postgresql = pkgs.postgresql;
        cabal2nix = pkgs.haskellPackages.cabal2nix;
        ccjs = pkgs.closurecompiler;
        vim = pkgs.vim;
    };
})
