{
  description = "Test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
  };

  outputs = { self, nix-doom-emacs, emacs-overlay, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ emacs-overlay.overlay ];
        };
      in
      {
        packages.default = nix-doom-emacs.package.${system} {
          doomPrivateDir = ./doom.d;
          emacsPackages = pkgs.emacsPackagesFor pkgs.emacsPgtk;
        };
      }
    );
}
