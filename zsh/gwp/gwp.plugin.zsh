function gwp() {
   pkgs="$@"
   nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$pkgs])" --run 'ghci'
}
