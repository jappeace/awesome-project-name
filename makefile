DB_NAME="awesome_db"

drop-db:
	dropdb $(DB_NAME) || true # never fail
create-db: drop-db
	createdb $(DB_NAME)

build: update-cabal
	cabal new-build all
build-js:
	cabal --project-file=cabal-ghcjs.project --builddir=dist-ghcjs new-build all

file-watch:
	scripts/watch.sh

update-cabal:
	hpack ./backend
	hpack ./common
	hpack ./frontend

EXTRA=""
enter:
	nix-shell -A shells.ghc --pure $(EXTRA)
enter-js:
	nix-shell -A shells.ghcjs --pure $(EXTRA)

run:
	./dist-newstyle/build/x86_64-linux/ghc-8.0.2/backend-0.1.0.0/c/webservice/build/webservice/webservice
