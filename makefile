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
	make enter EXTRA="--run \"scripts/watch.sh\""
file-watch-js:
	make enter-js EXTRA="--run \"scripts/watch-js.sh\""

update-cabal:
	hpack ./backend
	hpack ./common
	hpack ./frontend

EXTRA=""
enter:
	nix-shell -A shells.ghc --pure $(EXTRA)
enter-js:
	nix-shell -A shells.ghcjs --pure $(EXTRA)

run-js:
	firefox ./dist-ghcjs/build/x86_64-linux/ghcjs-0.2.1/frontend-0.1.0.0/c/webservice/build/webservice/webservice.jsexe/index.html
