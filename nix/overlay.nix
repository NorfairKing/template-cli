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
            buildStrictly (
              disableLibraryProfiling (
                # I turn off library profiling because it slows down the build.
                final.haskellPackages.callCabal2nixWithOptions name (final.gitignoreSource (../. + "/${name}")) "--no-hpack" { }
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
      paths = builtins.map justStaticExecutables (attrValues final.fooBarPackages);
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
                final.fooBarPackages // {
                  envparse = self.callHackage "envparse" "0.4.1" { };
                }
            );
      }
    );
}
