{ mkDerivation, aeson, base, bytestring, containers, fetchgit
, jsaddle, jsaddle-dom, lens, network-uri, reflex, reflex-dom-core
, stdenv, text, time, witherable
}:
mkDerivation {
  pname = "bulmex";
  version = "1.0.0.0";
  src = fetchgit {
    url = "https://github.com/jappeace/bulmex";
    sha256 = "0fbbzfg8qlxpw7ydh4qqgaqbi20jjm4pmf27hmizxnx6hmlsm50j";
    rev = "4458fcdd36a7c9b2bc947d3e7666fd09b37e5869";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/bulmex; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring containers jsaddle jsaddle-dom lens
    network-uri reflex reflex-dom-core text time witherable
  ];
  homepage = "https://github.com/jappeace/bulmex#readme";
  license = stdenv.lib.licenses.mit;
}
