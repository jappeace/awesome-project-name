{ mkDerivation, base, bytestring, case-insensitive, containers
, data-default, exceptions, fetchgit, ghcjs-dom, http-api-data
, http-media, jsaddle, jsaddle-dom, mtl, network-uri, reflex
, reflex-dom, reflex-dom-core, safe, servant, servant-auth, stdenv
, string-conversions, text, transformers
}:
mkDerivation {
  pname = "servant-reflex";
  version = "0.3.4";
  src = fetchgit {
    url = "https://github.com/jappeace/servant-reflex";
    sha256 = "1l1qmk165ggqfhyv1p58zyd9lp1nk6qqmvcym7mzk3q67rlql8m4";
    rev = "1cf8611afa07e864e9415dcb889ca4dfd9af5ef5";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring case-insensitive containers data-default exceptions
    ghcjs-dom http-api-data http-media jsaddle jsaddle-dom mtl
    network-uri reflex reflex-dom reflex-dom-core safe servant
    servant-auth string-conversions text transformers
  ];
  description = "Servant reflex API generator";
  license = stdenv.lib.licenses.bsd3;
}
