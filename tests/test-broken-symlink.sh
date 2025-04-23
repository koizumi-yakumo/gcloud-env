#!/usr/bin/env bash

# Test script for gcloud-env broken symlink handling
# This script tests that the gcloud-env script doesn't crash when encountering broken symbolic links

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Path to the gcloud-env script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GCLOUD_ENV_SCRIPT="$SCRIPT_DIR/../bin/gcloud-env"
GCLOUD_CONFIG_DIR="$HOME/.config/gcloud"
GCLOUD_ENV_DIR="$HOME/.config/gcloud-env"

# Test directories
TEST_DIR="/tmp/gcloud-env-broken-symlink-test"
PROJECT_DIR="$TEST_DIR/project"

# Test configuration
CONFIG="broken-symlink-test-config"

# Clean up function
cleanup() {
  echo "Cleaning up test directories..."
  rm -rf "$TEST_DIR"

  # Also clean up the test configuration
  echo "Cleaning up test configuration..."
  rm -rf "$GCLOUD_ENV_DIR/$CONFIG"

  echo "Done."
}

# Ensure cleanup happens even if the script is interrupted
trap cleanup EXIT INT TERM

# Run a test and check that it doesn't crash
run_test() {
  local test_name="$1"
  local command="$2"

  echo -n "Testing $test_name... "

  # Run the command and capture output and exit status
  local output
  local status
  output=$($command 2>&1) || status=$?

  # If the command exited with a non-zero status, it crashed
  if [ -n "$status" ]; then
    echo -e "${RED}FAILED${NC} (crashed with status $status)"
    echo "Command: $command"
    echo "Output: $output"
    cleanup
    exit 1
  else
    echo -e "${GREEN}PASSED${NC} (didn't crash)"
    echo "Output: $output"
  fi
}

# Setup test environment
setup() {
  echo "Setting up test environment..."

  # Clean up any existing test configuration
  rm -rf "$GCLOUD_ENV_DIR/$CONFIG"

  # Create test directory
  mkdir -p "$PROJECT_DIR"

  echo "Test environment ready."
}

# Main test function
main() {
  # Setup
  setup

  # Change to project directory
  cd "$PROJECT_DIR"
  echo "Changed to $PROJECT_DIR"

  # Initialize configuration
  bash "$GCLOUD_ENV_SCRIPT" init "$CONFIG"
  echo "Initialized $CONFIG for project"

  # Break the symbolic link
  echo "Breaking the symbolic link..."
  rm -rf "$GCLOUD_ENV_DIR/$CONFIG"
  
  # Test that various commands don't crash when encountering the broken symlink
  run_test "current command with broken symlink" \
    "bash $GCLOUD_ENV_SCRIPT current"

  run_test "list command with broken symlink" \
    "bash $GCLOUD_ENV_SCRIPT list"

  run_test "use command with broken symlink" \
    "bash $GCLOUD_ENV_SCRIPT use $CONFIG"

  # All tests passed
  echo -e "\n${GREEN}All broken symlink tests passed!${NC}"

  # Clean up
  cleanup
}

# Run the tests
main