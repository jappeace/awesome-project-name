{ mkDerivation, base, bytestring, fetchgit, hpack, http-media
, servant, stdenv, text
}:
mkDerivation {
  pname = "servant-fiat-content";
  version = "1.0.0";
  src = fetchgit {
    url = "https://github.com/jappeace/servant-fiat-content";
    sha256 = "0hsgwvj0m6zx7vf3ik3351jjabr8v85j24346slgmxwvrf0j8izz";
    rev = "0b30214e3b38d5eccca39c56816d098a8e01064b";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base bytestring http-media servant text
  ];
  libraryToolDepends = [ hpack ];
  preConfigure = "hpack";
  homepage = "https://github.com/jappeace/servant-fiat-content#readme";
  description = "Fiat content types";
  license = stdenv.lib.licenses.mit;
}
