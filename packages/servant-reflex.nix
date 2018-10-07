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
    url = "https://github.com/imalsogreg/servant-reflex";
    sha256 = "1cfhs5fvg298j0a3m0kjbspidmggdwbgws03krag9xp7fv736j6x";
    rev = "cc2d9b1f4f0c81bd98a7cb5313c5d2c802d5a50b";
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
