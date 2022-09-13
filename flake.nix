{
  description = "Test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-doom-emacs, emacs-overlay, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = nix-doom-emacs.package.${system} {
          doomPrivateDir = ./doom.d;
          emacsPackages = pkgs.emacsPackagesFor (pkgs.emacs.override { withPgtk = true; });
        };
      }
    );
}
