{ pkgs ? import <nixpkgs> {} }:

let  ghc = pkgs.haskellPackages.ghcWithPackages (p: [ p.split p.text p.random p.turtle
                                                      p.attoparsec
                                                    ]); in
with pkgs;

mkShell {
  buildInputs = [
    ghc
    ghcid
    hlint
  ];
}
