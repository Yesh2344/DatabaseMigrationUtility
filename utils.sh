#!/bin/bash

# Function to create a new migration
create_migration() {
  local name=$1
  local migration_dir=$2
  local migration_file="${migration_dir}/${name}.sh"

  # Create the migration file
  touch "$migration_file"

  # Add the migration file to the database
  echo "CREATE TABLE IF NOT EXISTS migrations (name VARCHAR(255) PRIMARY KEY, applied BOOLEAN DEFAULT FALSE)" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
  echo "INSERT INTO migrations (name, applied) VALUES ('${name}', FALSE)" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
}

# Function to apply a migration
apply_migration() {
  local name=$1
  local migration_dir=$2
  local migration_file="${migration_dir}/${name}.sh"

  # Check if the migration file exists
  if [ ! -f "$migration_file" ]; then
    echo "Migration file not found"
    exit 1
  fi

  # Apply the migration
  source "$migration_file"

  # Update the migration status
  echo "UPDATE migrations SET applied = TRUE WHERE name = '${name}'" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
}

# Function to revert a migration
revert_migration() {
  local name=$1
  local migration_dir=$2
  local migration_file="${migration_dir}/${name}.sh"

  # Check if the migration file exists
  if [ ! -f "$migration_file" ]; then
    echo "Migration file not found"
    exit 1
  fi

  # Revert the migration
  source "$migration_file"

  # Update the migration status
  echo "UPDATE migrations SET applied = FALSE WHERE name = '${name}'" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
}