{
  description = "EAE database: declarative schema, Supabase migrations and the db tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tools = import ./nix { inherit pkgs; };
      in
      {
        packages = {
          inherit (tools) db pg-delta;
          default = tools.db;
        };

        apps.default = {
          type = "app";
          program = "${tools.db}/bin/db";
        };

        devShells.default = pkgs.mkShell {
          packages = [ tools.db tools.pg-delta pkgs.supabase-cli pkgs.postgresql_17 ];
        };
      });
}
