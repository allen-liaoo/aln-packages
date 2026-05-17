{
  pkgs ? import <nixpkgs> { },
}:

{
  typst-mcp = pkgs.python3Packages.callPackage ./typst-mcp/typst-mcp.nix rec {
    typst = pkgs.typst;
    typst-docs = pkgs.callPackage ./typst-mcp/typst-docs.nix {
      typst = typst;
    };
    mcp = pkgs.python3Packages.callPackage ./typst-mcp/mcp.nix { };
  };
}
