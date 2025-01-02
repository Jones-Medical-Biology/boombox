{ pkgs ? import <nixos> {} }:
pkgs.haskellPackages.developPackage {
  root = ./.;
  modifier = drv:
    pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
      [ cabal-install
        threadscope
        pkgs.time
        pkgs.pango
        pkgs.gtk4
      ]);
}
