{ pkgs ? (import ../reflex-platform/nixpkgs {}) }:
(pkgs.haskell.lib.doHpack {
  name = "Minimal-example-of";
  buildInputs = [ pkgs.postgresql pkgs.zlib pkgs.haskellPackages.hpack ];
  src = ./.;
})
