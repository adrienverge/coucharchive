#!/bin/sh
# Copyright 2016 Adrien Vergé
# All rights reserved

set -eu

fail() {
  echo $1 >&2
  exit 1
}

usage() {
  fail "usage: $0 dump|load FILE"
}

[ -z ${1:-} ] && usage || ACTION="$1"
[ "$ACTION" != dump ] && [ "$ACTION" != load ] && usage
[ -z ${2:-} ] && usage || FILE="$2"
[ -z "$FILE" ] && usage

[ $ACTION = load ] && ([ -f $FILE ] || fail "$FILE does not exist")

[ -d /var/lib/couchdb ] || fail '/var/lib/couchdb does not exist'

COUCHDB_STATUS=$(systemctl is-active couchdb || true)
[ "$COUCHDB_STATUS" != active ] && [ "$COUCHDB_STATUS" != inactive ] \
  && fail 'service couchdb not found'

[ "$COUCHDB_STATUS" = active ] && \
  { echo "Stoping CouchDB..."; systemctl stop couchdb; }

if [ $ACTION = dump ]; then
  # Only the node name is really important in /etc/couchdb/vm.args
  echo "Saving /var/lib/couchdb and /etc/couchdb/vm.args..."
  tar -C / -czf "$FILE" \
    --transform 's|var/lib/||g' --transform 's|etc/couchdb/||g' \
    var/lib/couchdb etc/couchdb/vm.args
elif [ $ACTION = load ]; then
  rm -rf /var/lib/couchdb
  echo "Restoring /var/lib/couchdb..."
  tar -C /var/lib -xf "$FILE"
  chown -R couchdb:couchdb /var/lib/couchdb /var/lib/vm.args
  [ -f /etc/couchdb/vm.args ] && (
    cmp -s /etc/couchdb/vm.args /var/lib/vm.args || (
      echo "Making a backup of current /etc/couchdb/vm.args...";
      mv /etc/couchdb/vm.args /etc/couchdb/vm.args.backup-$(date +%F-%T)))
  echo "Restoring /etc/couchdb/vm.args..."
  mv /var/lib/vm.args /etc/couchdb/vm.args
fi

[ "$COUCHDB_STATUS" = active ] && \
  { echo "Starting CouchDB..."; systemctl start couchdb; }

echo "Success."
