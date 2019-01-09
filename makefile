DB_NAME="awesome_db"

drop-db:
	dropdb $(DB_NAME) || true # never fail
create-db: drop-db
	createdb $(DB_NAME)
	./dist-newstyle/build/x86_64-linux/ghc-8.4.3/backend-1.0.0.0/x/schema/build/schema/schema

OPTIMIZATION=-O0
build: update-cabal
	cabal new-build all -j --ghc-options $(OPTIMIZATION)
	make test OPTIMIZATION=$(OPTIMIZATION)

test:
	cabal new-test all -j --ghc-options $(OPTIMIZATION)

build-js:
	cabal --project-file=cabal-ghcjs.project --builddir=dist-ghcjs new-build all -j --ghcjs-options $(OPTIMIZATION)
	echo "https://github.com/ghcjs/ghcjs/wiki/Deployment"
	echo "don't forget to minify"

file-watch:
	scripts/watch.sh

update-cabal:
	hpack ./backend
	hpack ./common
	hpack ./frontend

EXTRA=""
enter:
	nix-shell --cores 0 -j 8 -A shells.ghc --pure $(EXTRA)
enter-js:
	nix-shell --cores 0 -j 8 -A shells.ghcjs --pure $(EXTRA)

run:
	./dist-newstyle/build/x86_64-linux/ghc-8.4.3/backend-1.0.0.0/x/webservice/build/webservice/webservice

clean:
	rm -fR dist dist-*


