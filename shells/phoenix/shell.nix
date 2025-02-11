# copy files to project folder
# nix-shell (or will load by default with direnv)
# postgres -h '' -k $PGHOST (in separate shell)
# createuser -d postgres
# mix archive.install hex phx_new
# mix phx.new .

with import <nixpkgs> { };
let
  basePackages = [
    elixir
    erlang
    elixir_ls
    # inotify-tools
    nodejs
    yarn
    postgresql
    process-compose
  ];
  PROJECT_ROOT = builtins.toString ./.;

  hooks = ''
     mkdir -p .nix-mix
     mkdir -p .nix-hex
     export MIX_HOME=${PROJECT_ROOT}/.nix-mix
     export HEX_HOME=${PROJECT_ROOT}/.nix-hex
     export PATH=$MIX_HOME/bin:$PATH
     export PATH=$HEX_HOME/bin:$PATH
     export LANG=en_NZ.UTF-8
     export ERL_AFLAGS="-kernel shell_history enabled"

     set -e
     export PGDIR=${PROJECT_ROOT}/postgres
     export PGHOST=$PGDIR
     export PGDATA=$PGDIR/data
     export PGLOG=$PGDIR/log
     export DATABASE_URL="postgresql:///postgres?host=$PGDIR"

     if test ! -d $PGDIR; then
       mkdir $PGDIR
     fi

    if [ ! -d $PGDATA ]; then
      echo 'Initializing postgresql database...'
      initdb $PGDATA --auth=trust >/dev/null
    fi

  '';

in
mkShell {
  buildInputs = basePackages;
  shellHook = hooks;
}
