function gwp() {
   pkgs="$@"
   nix-shell -p "haskellPackages.ghcWithHoogle (pkgs: with pkgs; [$pkgs])" --run 'zsh'
}

function gwi() {
   pkgs="$@"
   nix-shell -p "haskellPackages.ghcWithHoogle (pkgs: with pkgs; [$pkgs])" --run 'ghci'
}
