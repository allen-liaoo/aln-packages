{
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
    }:
    let
      forAllSystems = with nixpkgs.lib; genAttrs platforms.all;
      pkgsPerSystem = (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          lib = pkgs.lib;
        in
        (import ./wrappers { inherit wrappers pkgs lib; }) // (import ./pkgs { inherit pkgs lib; })
      );
    in
    {
      packages = forAllSystems pkgsPerSystem;
      legacyPackages = forAllSystems pkgsPerSystem;
      apps = forAllSystems (
        system:
        (
          with nixpkgs.lib;
          pipe system [
            pkgsPerSystem
            (filterAttrs (_: p: p ? meta && p.meta ? mainProgram))
            (mapAttrs (
              n: p: {
                type = "app";
                program = "${p}/bin/${p.meta.mainProgram}";
              }
            ))
          ]
        )
      );
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "git+file:///home/allenl/Code/nix-wrapper-modules";
      #"github:allen-liaoo/nix-wrapper-modules";
      #"github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
