{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.obsidian-headless = (pkgs.callPackage ./_pkg/obsidian-headless { }).overrideAttrs {
        src = inputs.obsidian-headless-src;
      };
    };
}
