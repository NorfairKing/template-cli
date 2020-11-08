let
  pkgs = import ./nix/pkgs.nix;
  pre-commit-hooks = (import ./ci.nix).pre-commit-hooks;
in
pkgs.mkShell {
  buildInputs = [
    pkgs.stack
  ];
  shellHook = ''
    ${pre-commit-hooks.shellHook}
  '';
}
