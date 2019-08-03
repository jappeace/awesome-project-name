{ mkDerivation, aeson, base, beam-core, bytestring, containers
, deepseq, dependent-map, dependent-sum, fetchgit, free, ghc-prim
, hashable, haskell-src-exts, microlens, mtl, parallel, pqueue
, pretty, scientific, stdenv, text, time, unordered-containers
, uuid-types, vector
}:
mkDerivation {
  pname = "beam-migrate";
  version = "0.4.0.0";
  src = fetchgit {
    url = "https://github.com/tathougies/beam.git";
    sha256 = "02xc4qgc7kb0rv8g9dq69p3p0d2psp6b4mzq444hsavnsw2wsn9y";
    rev = "737b73c6ec1c6aac6386bf9592a02a91f34a9478";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-migrate; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base beam-core bytestring containers deepseq dependent-map
    dependent-sum free ghc-prim hashable haskell-src-exts microlens mtl
    parallel pqueue pretty scientific text time unordered-containers
    uuid-types vector
  ];
  homepage = "https://travis.athougies.net/projects/beam.html";
  description = "SQL DDL support and migrations support library for Beam";
  license = stdenv.lib.licenses.mit;
}
