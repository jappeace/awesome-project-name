{ mkDerivation, base, bytestring, case-insensitive, containers
, data-default, exceptions, fetchgit, ghcjs-dom, http-api-data
, http-media, jsaddle, mtl, network-uri, reflex, reflex-dom-core
, safe, servant, servant-auth, stdenv, string-conversions, text
, transformers
}:
mkDerivation {
  pname = "servant-reflex";
  version = "0.3.3";
  src = fetchgit {
    url = "https://github.com/jappeace/servant-reflex";
    sha256 = "0ywg5pr8mkb0hwpznhcf7s3gqyvi2wvwkibw3mwnaw4ls06j4xmy";
    rev = "34362d2d51010af0326c8583da6f4ee64a7e08fe";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring case-insensitive containers data-default exceptions
    ghcjs-dom http-api-data http-media jsaddle mtl network-uri reflex
    reflex-dom-core safe servant servant-auth string-conversions text
    transformers
  ];
  description = "Servant reflex API generator";
  license = stdenv.lib.licenses.bsd3;
}

