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
    sha256 = "1lb2ppfjcjxfgan5rndwaa8s2lanhpdv258rbch38b0x5k4b6w1m";
    rev = "70564c84f07d7aca2b529b5e9aacc6731e9eb467";
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
