{ mkDerivation, aeson, base, beam-core, bytestring, containers
, deepseq, dependent-map, dependent-sum, fetchgit, free, ghc-prim
, hashable, haskell-src-exts, microlens, mtl, parallel, pqueue
, pretty, scientific, stdenv, text, time, unordered-containers
, uuid-types, vector
}:
mkDerivation {
  pname = "beam-migrate";
  version = "0.4.0.1";
  src = fetchgit {
    url = "https://github.com/tathougies/beam";
    sha256 = "1kyg22fmqnjy9xrjr1r6q786y57gxc6via57wwbdiy1cpq45bypy";
    rev = "0fe21e4cb1efc8229017ab182bbbe4d0458aeb3a";
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
