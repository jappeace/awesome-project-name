#! /bin/sh

set -x

while nix-shell --pure -p pkgs.inotify-tools --run  "inotifywait -r -e modify ./";
do
    make enter EXTRA="--run \"make build\"" && \
    make enter-js EXTRA="--run \"make build-js\""
done
