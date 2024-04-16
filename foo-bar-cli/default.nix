{ mkDerivation, autodocodec, autodocodec-yaml, autoexporter, base
, envparse, hspec, hspec-discover, lib, mtl, optparse-applicative
, path, path-io, text, yaml
}:
mkDerivation {
  pname = "foo-bar-cli";
  version = "0.0.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    autodocodec autodocodec-yaml base envparse mtl optparse-applicative
    path path-io text yaml
  ];
  libraryToolDepends = [ autoexporter ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base envparse hspec mtl optparse-applicative yaml
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/NorfairKing/foo-bar-cli#readme";
  license = lib.licenses.unfree;
  hydraPlatforms = lib.platforms.none;
  mainProgram = "foo-bar";
}
