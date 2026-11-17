{ pkgs, postgresql ? pkgs.postgresql_17 }:

let
  # Versions pinned in pg-delta/package.json; pre-1.0, so bumps are deliberate.
  pg-delta = pkgs.buildNpmPackage {
    pname = "pg-delta";
    version = "1.0.0-alpha.60";
    src = ./pg-delta;
    npmDepsHash = "sha256-bqds9DTcIpRzEtY5uOvNjKgXSUQRcPhLbXc4puIBxqg=";
    dontNpmBuild = true;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/lib $out/bin
      cp -r node_modules $out/lib/
      makeWrapper ${pkgs.nodejs}/bin/node $out/bin/pgdelta \
        --add-flags $out/lib/node_modules/@supabase/pg-delta/dist/cli/main.js
    '';
  };

  db = pkgs.writeShellApplication {
    name = "db";
    runtimeInputs = [
      postgresql
      pg-delta
      pkgs.supabase-cli
      pkgs.coreutils
      pkgs.findutils
    ];
    text = builtins.readFile ./db.sh;
  };
in
{
  inherit pg-delta db;
}
