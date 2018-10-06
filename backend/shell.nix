{ pkgs ? (import ../reflex-platform/nixpkgs {}) }:
(pkgs.haskell.lib.buildStackProject {
  name = "Minimal-example-of";
  buildInputs = [ pkgs.postgresql pkgs.zlib pkgs.haskellPackages.hpack pkgs.haskellPackages.cabal2nix ];
  src = ./.;
})
