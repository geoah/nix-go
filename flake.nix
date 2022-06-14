{
  description = ''
    Go releases for NixOS and Nix-based systems without source patches to core packages.

    Workaround for https://github.com/NixOS/nixpkgs/issues/125198 🤷
  '';

  inputs = { nixpkgs.url = "nixpkgs/nixos-22.05"; };

  outputs = { self, nixpkgs }: {
    packages = builtins.mapAttrs (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in builtins.mapAttrs (name: pkgs.callPackage ./go.nix)) (import ./dl.nix);
  };
}
