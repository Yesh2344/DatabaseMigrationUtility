#!/bin/bash

# Load the configuration
source config.sh

# Load the utilities
source utils.sh

# Display the help message
if [ "$1" == "--help" ]; then
  echo "Usage: ./main.sh [options]"
  echo ""
  echo "Options:"
  echo "  --init        Initializes the migration utility."
  echo "  --create      Creates a new migration."
  echo "  --apply       Applies a migration."
  echo "  --revert      Reverts a migration."
  echo ""
  exit 0
fi

# Initialize the migration utility
if [ "$1" == "--init" ]; then
  echo "Initializing the migration utility..."
  echo "CREATE TABLE IF NOT EXISTS migrations (name VARCHAR(255) PRIMARY KEY, applied BOOLEAN DEFAULT FALSE)" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
  exit 0
fi

# Create a new migration
if [ "$1" == "--create" ]; then
  local name=$2
  create_migration "$name" "$MIGRATION_DIR"
  exit 0
fi

# Apply a migration
if [ "$1" == "--apply" ]; then
  local name=$2
  apply_migration "$name" "$MIGRATION_DIR"
  exit 0
fi

# Revert a migration
if [ "$1" == "--revert" ]; then
  local name=$2
  revert_migration "$name" "$MIGRATION_DIR"
  exit 0
fi

# Display the version number
if [ "$1" == "--version" ]; then
  echo "Database Migration Utility 1.0"
  exit 0
fi

# Display an error message
echo "Invalid option"
exit 1