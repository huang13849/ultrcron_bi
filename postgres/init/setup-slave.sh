#!/bin/bash
set -e

# Define variables
MASTER_HOST=your_master_ip_or_hostname
REPLICATOR_USER=replicator
REPLICATOR_PASSWORD=replicatorpassword
SLAVE_DATA_DIR=./postgres/slave/data

# Remove any existing data on the slave
rm -rf "$SLAVE_DATA_DIR"/*

# Run pg_basebackup to synchronize data from the master
PGPASSWORD=$REPLICATOR_PASSWORD pg_basebackup -h $MASTER_HOST -D "$SLAVE_DATA_DIR" -U $REPLICATOR_USER -vP --wal-method=stream

# Create standby.signal file to indicate standby mode
touch "$SLAVE_DATA_DIR/standby.signal"

# Add replication settings to postgresql.conf
echo "primary_conninfo = 'host=$MASTER_HOST port=5432 user=$REPLICATOR_USER password=$REPLICATOR_PASSWORD'" >> "$SLAVE_DATA_DIR/postgresql.conf"
echo "primary_slot_name = 'replication_slot'" >> "$SLAVE_DATA_DIR/postgresql.conf"

echo "Base backup and configuration complete."