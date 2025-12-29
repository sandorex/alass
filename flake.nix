{
  description = "Automatic Language-Agnostic Subtitle Synchronization utility";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit self;
      system = "x86_64-linux";

      # using glib
      pkgs = import nixpkgs { inherit system; };

      cargoConfig = (builtins.fromTOML ./Cargo.toml);
    in
    rec {
      packages.${system}.default = pkgs.rustPlatform.buildRustPackage rec {
        pname = cargoConfig.package.name;
        version = cargoConfig.package.version;

        src = ./.;
        cargoLock = {
          lockFile = ./Cargo.lock;
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          git
          cargo
          rust-analyzer # lsp
        ];
      };
    };
}
