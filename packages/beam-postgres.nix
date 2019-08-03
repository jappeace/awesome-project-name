{ mkDerivation, aeson, attoparsec, base, beam-core, beam-migrate
, bytestring, case-insensitive, conduit, directory, fetchgit
, filepath, free, hashable, haskell-src-exts, hedgehog, lifted-base
, monad-control, mtl, network-uri, postgresql-libpq
, postgresql-simple, process, scientific, stdenv, tagged, tasty
, tasty-hunit, temporary, text, time, unordered-containers, uuid
, uuid-types, vector
}:
mkDerivation {
  pname = "beam-postgres";
  version = "0.4.0.0";
  src = fetchgit {
    url = "https://github.com/tathougies/beam.git";
    sha256 = "02xc4qgc7kb0rv8g9dq69p3p0d2psp6b4mzq444hsavnsw2wsn9y";
    rev = "737b73c6ec1c6aac6386bf9592a02a91f34a9478";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-postgres; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson attoparsec base beam-core beam-migrate bytestring
    case-insensitive conduit free hashable haskell-src-exts lifted-base
    monad-control mtl network-uri postgresql-libpq postgresql-simple
    scientific tagged text time unordered-containers uuid-types vector
  ];
  testHaskellDepends = [
    base beam-core beam-migrate bytestring directory filepath hedgehog
    postgresql-simple process tasty tasty-hunit temporary text uuid
  ];
  homepage = "http://tathougies.github.io/beam/user-guide/backends/beam-postgres";
  description = "Connection layer between beam and postgres";
  license = stdenv.lib.licenses.mit;
}
