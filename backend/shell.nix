{ pkgs ? (
   let 
    hostPkgs = import <nixpkgs> {};
    pinnedPkgs = hostPkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      # nixos-unstable as of <2018-10-19 vr> 
      rev = "0a7e258012b60cbe530a756f09a4f2516786d370";
      sha256 = "1qcnxkqkw7bffyc17mqifcwjfqwbvn0vs0xgxnjvh9w0ssl2s036";
    };
  in
  import pinnedPkgs {}
    # don't use reflex as it's very old and it's cabal2nix has no hpack
    # import ../reflex-platform/nixpkgs {}
  ) }:
(pkgs.haskell.lib.buildStackProject {
  name = "Minimal-example-of";
  buildInputs = [ pkgs.postgresql pkgs.zlib pkgs.haskellPackages.hpack pkgs.haskellPackages.cabal2nix ];
  src = ./.;
})
