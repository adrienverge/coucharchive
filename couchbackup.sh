#!/bin/sh
# Copyright 2016 Adrien Vergé
# All rights reserved

set -eu

fail() {
  echo $1 >&2
  exit 1
}

usage() {
  fail "usage: $0 HOST dump|load [FILE]"
}

[ -n "${BASH_SOURCE[0]}" ] && SCRIPT="${BASH_SOURCE[0]}" || SCRIPT="${(%):-%x}"
DIR="$(cd "$(dirname "$SCRIPT")" && pwd)"

[ -z ${1:-} ] && usage || HOST="$1"
[ -z "$HOST" ] && usage
[ -z ${2:-} ] && usage || ACTION="$2"
[ "$ACTION" != dump ] && [ "$ACTION" != load ] && usage
[ -z ${3:-} ] && FILE= || FILE="$3"

[ $ACTION = dump ] && [ -z "$FILE" ] && \
  FILE=/tmp/couchbackup-$(date +%F-%T).tar.gz
[ $ACTION = load ] && ([ -f "$FILE" ] || fail "$FILE does not exist")

R_FILE="/tmp/$(basename "$FILE")"

scp "$DIR/localbackup.sh" "$HOST":

if [ $ACTION = dump ]; then
  ssh -t "$HOST" sudo ./localbackup.sh $ACTION "$R_FILE"
  scp "$HOST:$R_FILE" "$FILE"
  ssh -t "$HOST" sudo rm "$R_FILE"
  echo "Dumped to $FILE"
elif [ $ACTION = load ]; then
  scp "$FILE" "$HOST:$R_FILE"
  ssh -t "$HOST" sudo ./localbackup.sh $ACTION "$R_FILE"
  ssh -t "$HOST" sudo rm "$R_FILE"
  echo "Loaded from $FILE"
fi
