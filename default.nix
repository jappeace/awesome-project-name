((import ./reflex) { }).project ({ pkgs, ... }: {
    packages = {
        common = ./common;
        backend = ./backend;
        frontend = ./frontend;
    };
    withHoogle = false;
    overrides = self: super:
    let 
    dontcheck = lib: pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.overrideCabal lib (drv: {
        # prevent hpack from being build for package.yaml on ghcjs
        libraryToolDepends = [ ]; 
        preConfigure = "";
      }));
    in
    rec {
      reflex-dom-helpers = self.callPackage ./packages/reflex-dom-helpers.nix { };
      servant-fiat-content = self.callPackage ./packages/servant-fiat-content.nix { };
      bulmex = self.callPackage ./packages/bulmex.nix { };
      beam-core = self.callPackage ./packages/beam-core.nix { };
      beam-migrate = self.callPackage ./packages/beam-migrate.nix { };
      beam-postgres = pkgs.haskell.lib.dontCheck (self.callPackage ./packages/beam-postgres.nix { });
      servant-reflex = self.callPackage ./packages/servant-reflex.nix { };
      servant = pkgs.haskell.lib.dontCheck (pkgs.haskell.lib.overrideCabal super.servant (drv: {
        testHaskellDepends = []; # servant has a dependency on testdoc 0.16.0 which fails to build in nix
      }));
      backend = dontcheck (pkgs.haskell.lib.overrideCabal super.backend (drv: { enableSharedExecutables = false; }));
      common = dontcheck (pkgs.haskell.lib.dontHaddock super.common);
      frontend = dontcheck (pkgs.haskell.lib.dontHaddock super.frontend);
    };

    shells = {
        ghc = ["common" "backend" "frontend"];
        ghcjs = ["common" "frontend"];
    };

    shellToolOverrides = ghc: super: {
        ccjs = pkgs.closurecompiler;
        vim = pkgs.vim;
        hpack = pkgs.haskellPackages.hpack;
    };
})
