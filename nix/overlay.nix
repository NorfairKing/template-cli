# This file is a nixpkgs overlay.
# Here we add our packages to whichever version of nixpkgs it is being laid over.
final: prev:
with final.lib;
with final.haskell.lib;
{

  # These are the 'release' versions of the packages that we define.
  # In particular, we use justStaticExecutables to reduce the size of the
  # closure.
  fooBarReleasePackages = mapAttrs (_: pkg: justStaticExecutables (doCheck pkg)) final.haskellPackages.fooBarPackages;

  # This attribute puts them all together into one.
  fooBarRelease = final.symlinkJoin {
    name = "foo-bar-release";
    paths = builtins.attrValues final.fooBarReleasePackages;
  };

  # This is where we specify specific haskell package versions.
  # These need to match the `extra-deps` part of `stack.yaml` for reproducibility.
  haskellPackages = prev.haskellPackages.override (old: {
    overrides =
      final.lib.composeExtensions (old.overrides or (_: _: { })) (
        self: super:
          let
            # This is where we define our Haskell packages.
            fooBarPkg = name:
              buildStrictly (self.callPackage (../${name}) { });
            # We can automatically add completion for the executables
            # because they use `optparse-applicative`
            fooBarPkgWithComp = exeName: name:
              self.generateOptparseApplicativeCompletions [ exeName ] (fooBarPkg name);
            fooBarPkgWithOwnComp = name: fooBarPkgWithComp name name;
            # This attribute contains all packages in this repository.
            fooBarPackages = {
              "foo-bar-cli" = addBuildDepend (fooBarPkgWithComp "foo-bar" "foo-bar-cli") self.autoexporter;
            };
          in
          fooBarPackages // { inherit fooBarPackages; }
      );
  }
  );
}
