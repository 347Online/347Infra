{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.obsidian-headless = (pkgs.callPackage ./obsidian-headless { }).overrideAttrs {
        src = inputs.obsidian-headless-src;
      };
    };
}
