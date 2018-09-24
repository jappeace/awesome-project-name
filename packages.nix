{ pkgs ? import <nixpkgs> {} }:
let 
    pinnedPkgs = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs-channels";
      # nixos-unstable as of 2017-11-13T08:53:10-00:00
      rev = "218ce4de5083a4b969df3db349b08f5a2737b628";
      sha256 = "0qc79dgjlx1by5qhn5xah5h6373g8nd9bdlh3bg96n7hi5min2h0";
    };
in
import pinnedPkgs {}
