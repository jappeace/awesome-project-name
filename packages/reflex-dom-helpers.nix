{ mkDerivation, base, fetchgit, reflex, reflex-dom-core, stdenv
, template-haskell, text
}:
mkDerivation {
  pname = "reflex-dom-helpers";
  version = "0.2.0.1";
  src = fetchgit {
    url = "https://github.com/layer-3-communications/reflex-dom-helpers";
    sha256 = "12k5jr1rif2yi1xa4a43gx1rchj1ywmh4m1wdj00mjslisjdndgm";
    rev = "e247c3ee5f9d957f994aeb57b9fe4d9f0a35beea";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base reflex reflex-dom-core template-haskell text
  ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/layer-3-communications/reflex-dom-helpers";
  description = "Html tag helpers for reflex-dom";
  license = stdenv.lib.licenses.bsd3;
}
