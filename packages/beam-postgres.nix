{ mkDerivation, aeson, base, beam-core, beam-migrate, bytestring
, case-insensitive, conduit, fetchgit, free, hashable
, haskell-src-exts, lifted-base, monad-control, mtl, network-uri
, postgresql-libpq, postgresql-simple, scientific, stdenv, tagged
, text, time, unordered-containers, uuid-types, vector
}:
mkDerivation {
  pname = "beam-postgres";
  version = "0.3.2.1";
  src = fetchgit {
    url = "https://github.com/tathougies/beam";
    sha256 = "06gf5s3iqznd0gciacx9qbarlis7r0pv80iyid8slkyhxn42y3z7";
    rev = "24a96f2f8d53558c33f1fe4031bd0687f9511e01";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/beam-postgres; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base beam-core beam-migrate bytestring case-insensitive
    conduit free hashable haskell-src-exts lifted-base monad-control
    mtl network-uri postgresql-libpq postgresql-simple scientific
    tagged text time unordered-containers uuid-types vector
  ];
  homepage = "http://tathougies.github.io/beam/user-guide/backends/beam-postgres";
  description = "Connection layer between beam and postgres";
  license = stdenv.lib.licenses.mit;
}
