{
  lib,
  nodejs_24,
  pnpm_10,
  stdenv,
  makeBinaryWrapper,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "obsidian-headless";
  version = "0.0.9";

  src = ./.;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs_24
    pnpm_10
    pnpm_10.configHook
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-vCZt7TbekVpcA9Km20E8OUB9xk4X716lh9iMB9rszGk=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/obsidian-headless"
    cp -r . "$out/lib/obsidian-headless"

    mkdir -p "$out/bin"
    makeBinaryWrapper ${nodejs_24}/bin/node $out/bin/ob --add-flags "$out/lib/obsidian-headless/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Headless client for Obsidian Sync";
    homepage = "https://github.com/obsidianmd/obsidian-headless";
    # license = lib.licenses.unfree; # This should be uncommented if ever actually merged into nixpkgs
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ob";
  };
})
