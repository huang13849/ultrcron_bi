#!/bin/bash
set -e

# Stop PostgreSQL server
pg_ctl stop

# Clean old data directory
rm -rf "$PGDATA"/*

# Perform base backup from master
PGPASSWORD=masterpassword pg_basebackup -h 209.141.34.146 -D "$PGDATA" -U replicator -vP --wal-method=stream

# Create recovery configuration file
cat <<EOF > "$PGDATA/recovery.conf"
standby_mode = 'on'
primary_conninfo = 'host=209.141.34.146 port=5432 user=replicator password=replicatorpassword'
primary_slot_name = 'replication_slot'
trigger_file = '/tmp/promote_to_master'
EOF

# Start PostgreSQL server
pg_ctl start

