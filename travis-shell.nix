{ pkgs ? import (builtins.fetchGit {
    # newer pin allows britanny
    name = "nixos-pin-19.10.2019";
    url = https://github.com/nixos/nixpkgs/;
    rev = "8253c106c63f575669da61c41914891e55f68881";
}) { }}:

# Tools we need for testing if the source code is sane.
# Not neccisarly needed for the project
pkgs.mkShell{
    buildInputs = [
        pkgs.hlint
        pkgs.haskellPackages.brittany
        pkgs.findutils
        pkgs.fd
    ];
}
