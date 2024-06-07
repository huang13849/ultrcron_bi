#!/bin/bash
set -e

# Define variables
POSTGRES_MASTER_HOST=209.141.34.146
POSTGRES_REPLICATOR_USER=replicator
POSTGRES_REPLICATOR_PASSWORD=replicatorpassword
SLAVE_DATA_DIR=../../postgres/slave/data

# Remove any existing data on the slave
rm -rf "$SLAVE_DATA_DIR"/*

# Run pg_basebackup to synchronize data from the master
PGPASSWORD=$POSTGRES_REPLICATOR_PASSWORD pg_basebackup -h $POSTGRES_MASTER_HOST -D "$SLAVE_DATA_DIR" -U $POSTGRES_REPLICATOR_USER -vP --wal-method=stream

# Create standby.signal file to indicate standby mode
touch "$SLAVE_DATA_DIR/standby.signal"

# Add replication settings to postgresql.conf
echo "primary_conninfo = 'host=$POSTGRES_MASTER_HOST port=5432 user=$POSTGRES_REPLICATOR_USER password=$POSTGRES_REPLICATOR_PASSWORD'" >> "$SLAVE_DATA_DIR/postgresql.conf"
echo "primary_slot_name = 'replication_slot'" >> "$SLAVE_DATA_DIR/postgresql.conf"

echo "Base backup and configuration complete."