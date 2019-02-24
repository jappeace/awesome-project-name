{ mkDerivation, aeson, base, bytestring, containers, dlist
, fetchgit, free, ghc-prim, hashable, microlens, mtl, network-uri
, stdenv, tagged, tasty, tasty-hunit, text, time, vector-sized
}:
mkDerivation {
  pname = "beam-core";
  version = "0.7.2.3";
  src = fetchgit {
    url = "https://github.com/tathougies/beam";
    sha256 = "06gf5s3iqznd0gciacx9qbarlis7r0pv80iyid8slkyhxn42y3z7";
    rev = "24a96f2f8d53558c33f1fe4031bd0687f9511e01";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring containers dlist free ghc-prim hashable
    microlens mtl network-uri tagged text time vector-sized
  ];
  testHaskellDepends = [
    base bytestring tasty tasty-hunit text time
  ];
  homepage = "http://travis.athougies.net/projects/beam.html";
  description = "Type-safe, feature-complete SQL query and manipulation interface for Haskell";
  license = stdenv.lib.licenses.mit;
}
