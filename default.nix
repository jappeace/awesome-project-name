let reflex-platform = builtins.fetchGit {
      url = https://github.com/reflex-frp/reflex-platform.git;
      ref = "develop";
      rev = "f3ff81d519b226752c83eefd4df6718539c3efdc";
    };
in (import reflex-platform { }).project ({ pkgs, ... }: {
    packages = {
        backend = ./backend;
    };
    overrides = self: super: rec {
      grenade = self.callPackage ./packages/grenade.nix { }; # https://github.com/HuwCampbell/grenade/issues/87
      # grenade = pkgs.haskell.lib.dontCheck (self.callPackage ./packages/grenade.nix { }); # workaround 
    };

    shells = {
        ghc = ["backend"];
    };
})
