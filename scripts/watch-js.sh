#! /bin/sh

set -x

while inotifywait -r -e modify ./;
    do make build-js;
done
