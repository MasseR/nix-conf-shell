function gwp() {
   pkgs="$@"
   nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz -p "ghcid" -p "haskellPackages.ghcWithHoogle (pkgs: with pkgs; [$pkgs])" --run 'zsh'
}

function gwi() {
   pkgs="$@"
   nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$pkgs])" --run 'ghci'
}
