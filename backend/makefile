DB_NAME="awesome_db"
drop-db:
	dropdb $(DB_NAME) || true # never fail
create-db: drop-db
	createdb $(DB_NAME)

update-build:
	cabal2nix --hpack --extra-arguments lib . > ./default.nix
