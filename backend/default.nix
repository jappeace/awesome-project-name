{ mkDerivation, aeson, base, beam-core, beam-migrate, beam-postgres
, bytestring, hpack, lib, postgresql-simple, servant-server, stdenv
, text, wai, warp
}:
mkDerivation {
  pname = "awesome-project-name";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base beam-core beam-migrate beam-postgres bytestring
    postgresql-simple servant-server text wai warp
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [
    aeson base beam-core beam-migrate beam-postgres bytestring
    postgresql-simple servant-server text wai warp
  ];
  testHaskellDepends = [
    aeson base beam-core beam-migrate beam-postgres bytestring
    postgresql-simple servant-server text wai warp
  ];
  preConfigure = "hpack";
  homepage = "https://github.com/githubuser/awesome-project-name#readme";
  license = stdenv.lib.licenses.bsd3;
}
