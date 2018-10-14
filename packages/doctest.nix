{ mkDerivation, base, base-compat, code-page, deepseq, directory
, fetchgit, filepath, ghc, ghc-paths, hspec, HUnit, mockery
, process, QuickCheck, setenv, silently, stdenv, stringbuilder, syb
, transformers, with-location
}:
mkDerivation {
  pname = "doctest";
  version = "0.16.0";
  src = fetchgit {
    url = "https://github.com/sol/doctest";
    sha256 = "141k52jgmk7invb655x7qykjcb4kdjkzc6q2rlwkygp8ynbv4m3l";
    rev = "1cc1902b602ed3c6cf9a1c8c2144acb27435dc17";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base base-compat code-page deepseq directory filepath ghc ghc-paths
    process syb transformers
  ];
  executableHaskellDepends = [
    base base-compat code-page deepseq directory filepath ghc ghc-paths
    process syb transformers
  ];
  testHaskellDepends = [
    base base-compat code-page deepseq directory filepath ghc ghc-paths
    hspec HUnit mockery process QuickCheck setenv silently
    stringbuilder syb transformers with-location
  ];
  homepage = "https://github.com/sol/doctest#readme";
  description = "Test interactive Haskell examples";
  license = stdenv.lib.licenses.mit;
}
