{
  pkgs,
}:

pkgs.python3Packages.callPackage ./typst-mcp.nix rec {
  typst = pkgs.typst;
  typst-docs = pkgs.callPackage ./typst-docs.nix {
    typst = typst;
  };
  mcp = pkgs.python3Packages.callPackage ./mcp.nix { };
}
