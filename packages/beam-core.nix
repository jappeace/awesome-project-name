{ mkDerivation, aeson, base, bytestring, containers, dlist
, fetchgit, free, ghc-prim, hashable, microlens, mtl, network-uri
, scientific, stdenv, tagged, tasty, tasty-hunit, text, time
, vector, vector-sized
}:
mkDerivation {
  pname = "beam-core";
  version = "0.8.0.0";
  src = fetchgit {
    url = "https://github.com/tathougies/beam.git";
    sha256 = "02xc4qgc7kb0rv8g9dq69p3p0d2psp6b4mzq444hsavnsw2wsn9y";
    rev = "737b73c6ec1c6aac6386bf9592a02a91f34a9478";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring containers dlist free ghc-prim hashable
    microlens mtl network-uri scientific tagged text time vector
    vector-sized
  ];
  testHaskellDepends = [
    base bytestring tasty tasty-hunit text time
  ];
  homepage = "http://travis.athougies.net/projects/beam.html";
  description = "Type-safe, feature-complete SQL query and manipulation interface for Haskell";
  license = stdenv.lib.licenses.mit;
}
