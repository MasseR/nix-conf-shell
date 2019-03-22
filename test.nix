{ lib, pkgs, ... }:

{
  programs.home-manager.enable = true;
  imports = [ ./default.nix ];
}
