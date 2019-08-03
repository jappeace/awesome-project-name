((import ./reflex) { }).project ({ pkgs, ... }: {
    packages = {
        common = ./common;
        backend = ./backend;
        frontend = ./frontend;
    };
    overrides = self: super: rec {
      servant-fiat-content = self.callPackage ./packages/servant-fiat-content.nix { };
      bulmex = self.callPackage ./packages/bulmex.nix { };
      beam-core = self.callPackage ./packages/beam-core.nix { };
      beam-migrate = self.callPackage ./packages/beam-migrate.nix { };
      beam-postgres = pkgs.haskell.lib.dontCheck (self.callPackage ./packages/beam-postgres.nix { });
      servant-reflex = self.callPackage ./packages/servant-reflex.nix { };
      servant = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.overrideCabal super.servant (drv: {
        testHaskellDepends = []; # servant has a dependency on testdoc 0.16.0 which fails to build in nix
      }));
      backend = pkgs.haskell.lib.overrideCabal super.backend (drv: { enableSharedExecutables = false; });
      common = pkgs.haskell.lib.dontHaddock (pkgs.haskell.lib.overrideCabal super.common (drv: { libraryToolDepends = []; }));
      frontend = pkgs.haskell.lib.dontHaddock (pkgs.haskell.lib.overrideCabal super.frontend (drv: { libraryToolDepends = []; }));
    };

    shells = {
        ghc = ["common" "backend" "frontend"];
        ghcjs = ["common" "frontend"];
    };

    shellToolOverrides = ghc: super: {
        ccjs = pkgs.closurecompiler;
        vim = pkgs.vim;
    };
})
