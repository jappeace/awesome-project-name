let reflex-platform = builtins.fetchGit {
      url = https://github.com/reflex-frp/reflex-platform.git;
      ref = "develop";
      rev = "cb5c820d66ca89c114792966c361cb6e0152ce92";
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

