final: previous:
with final.lib;
with final.haskell.lib;
let
  templatePkg =
    name:
      dontHaddock (
        doBenchmark (
          addBuildDepend (
            failOnAllWarnings (
              disableLibraryProfiling (
                final.haskellPackages.callCabal2nix name (final.gitignoreSource (../. + "/${name}")) {}
              )
            )
          ) (final.haskellPackages.autoexporter)
        )
      );
  templatePkgWithComp =
    exeName: name:
      generateOptparseApplicativeCompletion exeName (templatePkg name);
  templatePkgWithOwnComp = name: templatePkgWithComp name name;
in
{
  templatePackages = {
    "template-cli" = templatePkgWithComp "template" "template-cli";
  };
  templateRelease =
    final.symlinkJoin {
      name = "template-release";
      paths = attrValues final.templatePackages;
    };
  haskellPackages =
    previous.haskellPackages.override (
      old:
        {
          overrides =
            final.lib.composeExtensions (
              old.overrides or (
                _:
                _:
                  {}
              )
            ) (
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
                      self.callCabal2nix "envparse" (envparseRepo) {}
                    );
                in
                  final.templatePackages // {
                    envparse = self.callHackage "envparse" "0.4.1" {};
                  }
            );
        }
    );
}
