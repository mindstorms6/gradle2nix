{
  description = "Wrap Gradle builds with Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ kotlin-language-server ktlint pkgs.openjdk11 ];
        };

        packages.default = import ./default.nix { inherit pkgs; };

        apps.default = {
          type = "app";
          program = "${packages.default}/bin/gradle2nix";
        };
      });
}
