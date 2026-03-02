# Minor edit
# Minor edit
#!/bin/bash

# Load the configuration
source config.sh

# Load the utilities
source utils.sh

# Test the create migration function
echo "Testing create migration function..."
create_migration "test_migration" "$MIGRATION_DIR"
if [ -f "${MIGRATION_DIR}/test_migration.sh" ]; then
  echo "Test passed"
else
  echo "Test failed"
  exit 1
fi

# Test the apply migration function
echo "Testing apply migration function..."
apply_migration "test_migration" "$MIGRATION_DIR"
if [ $(echo "SELECT applied FROM migrations WHERE name = 'test_migration'" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" | grep -c "t") -eq 1 ]; then
  echo "Test passed"
else
  echo "Test failed"
  exit 1
fi

# Test the revert migration function
echo "Testing revert migration function..."
revert_migration "test_migration" "$MIGRATION_DIR"
if [ $(echo "SELECT applied FROM migrations WHERE name = 'test_migration'" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" | grep -c "f") -eq 1 ]; then
  echo "Test passed"
else
  echo "Test failed"
  exit 1
fi

echo "All tests passed"
exit 0