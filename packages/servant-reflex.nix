{ mkDerivation, base, bytestring, case-insensitive, containers
, data-default, exceptions, fetchgit, ghcjs-dom, http-api-data
, http-media, jsaddle, jsaddle-dom, mtl, network-uri, reflex
, reflex-dom-core, safe, servant, servant-auth, stdenv
, string-conversions, text, transformers
}:
mkDerivation {
  pname = "servant-reflex";
  version = "0.3.5";
  src = fetchgit {
    url = "https://github.com/jappeace/servant-reflex";
    sha256 = "1s26pa3znib9hpsrj8yqjvq30ps49zk2ifm54falsk8mlx9pz8fv";
    rev = "1a15ab1cecb1ae49962234349f8d357d6ba47db7";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring case-insensitive containers data-default exceptions
    ghcjs-dom http-api-data http-media jsaddle jsaddle-dom mtl
    network-uri reflex reflex-dom-core safe servant servant-auth
    string-conversions text transformers
  ];
  description = "servant API generator for reflex apps";
  license = stdenv.lib.licenses.bsd3;
}
