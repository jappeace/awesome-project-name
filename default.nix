let reflex-platform = builtins.fetchGit {
      url = https://github.com/reflex-frp/reflex-platform.git;
      ref = "develop";
      rev = "f3ff81d519b226752c83eefd4df6718539c3efdc";
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
      # Glob = self.callPackage ./packages/glob.nix { }; # ghc8_4 glob tests for 0.9.2 failed, delete on upgrade
      backend = pkgs.haskell.lib.overrideCabal super.backend (drv: { enableSharedExecutables = false; });
      common = pkgs.haskell.lib.overrideCabal super.common (drv: { libraryToolDepends = []; });
      frontend = pkgs.haskell.lib.overrideCabal super.frontend (drv: { libraryToolDepends = []; });
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



