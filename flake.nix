{
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
    }:
    let
      forAllSystems = with nixpkgs.lib; genAttrs platforms.all;
      packages' = (
        system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          lib = pkgs.lib;
        in
        (
          import ./wrappers { inherit wrappers pkgs lib; }
        ) //
        (
          import ./pkgs { inherit pkgs; }
        )
      );
    in
    {
      packages = forAllSystems packages';
      legacyPackages = forAllSystems packages';
      apps = forAllSystems (system: (with nixpkgs.lib;
        pipe system [
          packages'
          (filterAttrs (_: p: p ? meta && p.meta ? mainProgram))
          (mapAttrs (n: p: {
            type = "app";
            program = "${p}/bin/${p.meta.mainProgram}";
          }))
        ]
      ));
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:allen-liaoo/nix-wrapper-modules";
      #"github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
