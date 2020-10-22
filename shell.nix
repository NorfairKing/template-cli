let
  pkgs = import ./nix/pkgs.nix;
  pre-commit-hooks = (import ./ci.nix).pre-commit-hooks;
  stripeCli =
    let
      src = builtins.fetchurl {
        url = "https://github.com/stripe/stripe-cli/releases/download/v1.5.3/stripe_1.5.3_linux_x86_64.tar.gz";
        sha256 = "sha256:0hbiv043h00n4xhzs1hbvgn7z1v91mb8djbd51qmbm12ab9qdr6c";
      };
    in
      pkgs.stdenv.mkDerivation {
        name = "stripe-cli";
        buildCommand = ''
          mkdir -p $out/bin
          tar xvzf ${src} --directory $out/bin
        '';
      };
in
pkgs.mkShell {
  buildInputs = [
    stripeCli
    pkgs.stack
  ];
  shellHook = ''
    ${pre-commit-hooks.shellHook}
  '';
}
