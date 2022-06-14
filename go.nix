{ lib, stdenv, autoPatchelfHook, fetchurl, os, arch, version, url, hash }:
stdenv.mkDerivation {
  name = "go${version}-${os}-${arch}";

  src = fetchurl { inherit url hash; };

  dontStrip = stdenv.hostPlatform.isDarwin;

  # Patch ELF interpreter in all executable files. Go uses version in tagged
  # releases for tool IDs embedded in compiler output, and we don’t apply any
  # patches to the standard library unlike nixpkgs.
  #
  # That is, the compiler output should be the same.
  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/go $out/bin
    cp -r . $out/share/go
    for f in bin/*; do
      ln -s ../share/go/$f $out/$f
    done
    runHook postInstall
  '';
}
