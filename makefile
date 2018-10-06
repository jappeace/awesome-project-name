DB_NAME="awesome_db"

drop-db:
	dropdb $(DB_NAME) || true # never fail
create-db: drop-db
	createdb $(DB_NAME)

build:
	cabal new-build all
build-js:
	cabal --project-file=cabal-ghcjs.project --builddir=dist-ghcjs new-build all

file-watch:
	nix-shell --run "while inotifywait -r -e modify ./; do make build; done"
file-watch-js:
	nix-shell --run "while inotifywait -r -e modify ./; do make build-js; done"

update-cabal:
	hpack ./backend
	hpack ./common
	hpack ./frontend

enter:
	nix-shell -A shells.ghc
enter-js:
	nix-shell -A shells.ghcjs
