{ mkDerivation, aeson, base, beam-core, bytestring, containers
, deepseq, dependent-map, dependent-sum, fetchgit, free, ghc-prim
, hashable, haskell-src-exts, mtl, parallel, pqueue, pretty
, scientific, stdenv, text, time, unordered-containers, uuid-types
, vector
}:
mkDerivation {
  pname = "beam-migrate";
  version = "0.3.2.0";
  src = fetchgit {
    url = "https://github.com/tathougies/beam";
    sha256 = "06gf5s3iqznd0gciacx9qbarlis7r0pv80iyid8slkyhxn42y3z7";
    rev = "24a96f2f8d53558c33f1fe4031bd0687f9511e01";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-migrate; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base beam-core bytestring containers deepseq dependent-map
    dependent-sum free ghc-prim hashable haskell-src-exts mtl parallel
    pqueue pretty scientific text time unordered-containers uuid-types
    vector
  ];
  homepage = "https://travis.athougies.net/projects/beam.html";
  description = "SQL DDL support and migrations support library for Beam";
  license = stdenv.lib.licenses.mit;
}
