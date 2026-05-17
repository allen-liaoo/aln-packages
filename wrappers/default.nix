{
  wrappers,
  pkgs, # instantiated with system
  lib,
}:

lib.pipe ./. [
  builtins.readDir
  (lib.filterAttrs (n: t: t != "directory" && n != "default.nix" && lib.hasSuffix ".nix" n))
  (lib.mapAttrs' (
    n: _:
    let
      wrapperName = lib.removeSuffix ".nix" n;
      myWrapper = import ./${n};
    in
    {
      name = wrapperName;
      value = (wrappers.wrappers.${wrapperName}.apply myWrapper).wrap { inherit pkgs; }; # apply config then instantiate with pkg (with system)
    }
  ))
]
