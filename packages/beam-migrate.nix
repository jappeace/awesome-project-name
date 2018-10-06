{ mkDerivation, aeson, base, beam-core, bytestring, containers
, deepseq, dependent-map, dependent-sum, free, ghc-prim, hashable
, haskell-src-exts, mtl, parallel, pqueue, pretty, scientific
, stdenv, text, time, unordered-containers, uuid-types, vector
}:
mkDerivation {
  pname = "beam-migrate";
  version = "0.3.2.0";
  sha256 = "1a6m27cpa2xlwmwfi1374p3a23i2hm8fjfsl6bdn0zpnawgi5rhf";
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
