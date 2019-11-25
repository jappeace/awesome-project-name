{ pkgs ? import ./reflex/packages.nix }:

pkgs.mkShell{
    buildInputs = [
        pkgs.cabal2nix 
        pkgs.haskellPackages.hpack
    ];
}
