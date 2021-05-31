# This file is a nixpkgs overlay.
# Here we add our packages to whichever version of nixpkgs it is being laid over.
final: previous:
with final.lib;
with final.haskell.lib;
let
  # This is where we define our Haskell packages.
  fooBarPkg =
    name:
    dontHaddock (
      doBenchmark (
        addBuildDepend
          (
            failOnAllWarnings (
              disableLibraryProfiling (
                # I turn off library profiling because it slows down the build.
                final.haskellPackages.callCabal2nix name (final.gitignoreSource (../. + "/${name}")) { }
              )
            )
          )
          (final.haskellPackages.autoexporter)
      )
    );
  # We can automatically add completion for the executables
  # because they use `optparse-applicative`
  fooBarPkgWithComp =
    exeName: name:
    generateOptparseApplicativeCompletion exeName (fooBarPkg name);
  fooBarPkgWithOwnComp = name: fooBarPkgWithComp name name;
in
{
  # This attribute contains all packages in this repository.
  fooBarPackages = {
    "foo-bar-cli" = fooBarPkgWithComp "foo-bar" "foo-bar-cli";
  };

  # This attribute puts them all together into one.
  fooBarRelease =
    final.symlinkJoin {
      name = "foo-bar-release";
      paths = attrValues final.fooBarPackages;
    };

  # This is where we specify specific haskell package versions.
  # These need to match the `extra-deps` part of `stack.yaml` for reproducibility.
  haskellPackages =
    previous.haskellPackages.override (
      old:
      {
        overrides =
          final.lib.composeExtensions
            (
              old.overrides or (
                _:
                _:
                { }
              )
            )
            (
              self: super:
                with final.haskell.lib;
                let
                  # envparse
                  envparseRepo =
                    final.fetchFromGitHub {
                      owner = "supki";
                      repo = "envparse";
                      rev = "de5944fb09e9d941fafa35c0f05446af348e7b4d";
                      sha256 =
                        "sha256:0piljyzplj3bjylnxqfl4zpc3vc88i9fjhsj06bk7xj48dv3jg3b";
                    };
                  envparsePkg =
                    dontCheck (
                      self.callCabal2nix "envparse" (envparseRepo) { }
                    );
                in
                final.fooBarPackages // {
                  envparse = self.callHackage "envparse" "0.4.1" { };
                }
            );
      }
    );
}
