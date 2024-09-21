let
  pkgs = import <unstable> { };
in
pkgs.haskellPackages.developPackage {
  root = ./.;
  modifier = drv:
    pkgs.haskell.lib.addBuildTools drv (with pkgs.haskellPackages;
      [ cabal-install
        ghcid
        ghc_9_10_1
        ghcide
        base_4_20_0_1
      ]);
}
