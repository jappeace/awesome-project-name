#! /bin/sh

set -x

while make enter EXTRA="--run \"inotifywait -r -e modify ./\"";
do
    make enter EXTRA="--run \"make build\"" && \
    make enter-js EXTRA="--run \"make build-js\""
done
