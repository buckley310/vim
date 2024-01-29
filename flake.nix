{
  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      packages = forAllSystems (system:
        let
          inherit (nixpkgs.legacyPackages.${system}) pkgs;
        in
        {
          default = pkgs.callPackage ./default.nix { };
        });
    };
}
