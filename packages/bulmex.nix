{ mkDerivation, aeson, base, bytestring, containers, fetchgit
, jsaddle, jsaddle-dom, lens, network-uri, reflex, reflex-dom-core
, reflex-dom-helpers, stdenv, text, time, witherable
}:
mkDerivation {
  pname = "bulmex";
  version = "2.0.0";
  src = fetchgit {
    url = "https://github.com/jappeace/bulmex";
    sha256 = "00gmnnk1y2lp0mfx04zmiq4fgxvl5kmg5gydlrz813bq5bd7jkbw";
    rev = "161afcd390ed249f807ec7bf514a52c31799ea60";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/bulmex; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base bytestring containers jsaddle jsaddle-dom lens
    network-uri reflex reflex-dom-core reflex-dom-helpers text time
    witherable
  ];
  homepage = "https://github.com/jappeace/bulmex#readme";
  description = "Reflex infused with bulma (css)";
  license = stdenv.lib.licenses.mit;
}
