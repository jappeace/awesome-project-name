{ mkDerivation, ad, base, bytestring, cereal, constraints
, containers, criterion, deepseq, fetchgit, hedgehog, hmatrix
, MonadRandom, mtl, primitive, random, reflection, singletons
, stdenv, text, transformers, typelits-witnesses, vector
}:
mkDerivation {
  pname = "grenade";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/HuwCampbell/grenade";
    sha256 = "1nzzacpiz86z3svvi2lpczzkv4algjfw3m2h2pqsw5n44xp8b320";
    rev = "f729b291e40a9044d95d49d31bce3149a5b9d599";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base bytestring cereal containers deepseq hmatrix MonadRandom
    primitive singletons vector
  ];
  testHaskellDepends = [
    ad base constraints hedgehog hmatrix MonadRandom mtl random
    reflection singletons text transformers typelits-witnesses vector
  ];
  benchmarkHaskellDepends = [ base bytestring criterion hmatrix ];
  description = "Practical Deep Learning in Haskell";
  license = stdenv.lib.licenses.bsd2;
}
