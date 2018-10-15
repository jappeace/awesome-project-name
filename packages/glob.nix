{ mkDerivation, base, containers, directory, dlist, fetchgit
, filepath, HUnit, QuickCheck, stdenv, test-framework
, test-framework-hunit, test-framework-quickcheck2, transformers
, transformers-compat
}:
mkDerivation {
  pname = "Glob";
  version = "0.9.3";
  src = fetchgit {
    url = "https://github.com/Deewiant/glob";
    sha256 = "0dskqz6prk59f5haba29bysr9p9ir5miclrxy4zmjmw68p08dlzb";
    rev = "0856914adfd2b6e44b27dfd5775ced5189791de6";
  };
  libraryHaskellDepends = [
    base containers directory dlist filepath transformers
    transformers-compat
  ];
  testHaskellDepends = [
    base containers directory dlist filepath HUnit QuickCheck
    test-framework test-framework-hunit test-framework-quickcheck2
    transformers transformers-compat
  ];
  homepage = "http://iki.fi/matti.niemenmaa/glob/";
  description = "Globbing library";
  license = stdenv.lib.licenses.bsd3;
}
