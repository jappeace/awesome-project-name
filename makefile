DB_NAME="awesome_db"

drop-db:
	dropdb $(DB_NAME) || true # never fail
create-db: drop-db
	createdb $(DB_NAME)

file-watch:
	nix-shell --run "while inotifywait -r -e modify ./; do cabal new-build all; done"

update-build:
	hpack ./backend
	hpack ./common
	hpack ./frontend
