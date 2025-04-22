#!/usr/bin/env bash

# Test script for gcloud-env auto-switching functionality
# This script tests that configurations are automatically switched when changing directories

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Path to the gcloud-env script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GCLOUD_ENV_SCRIPT="$SCRIPT_DIR/../bin/gcloud-env"

# Test directories
TEST_DIR="/tmp/gcloud-env-auto-switch-test"
PROJECT1_DIR="$TEST_DIR/project1"
PROJECT2_DIR="$TEST_DIR/project2"
PROJECT1_SUBDIR="$PROJECT1_DIR/subdir"

# Test configurations
CONFIG1="auto-test-config1"
CONFIG2="auto-test-config2"

# Clean up function
cleanup() {
  echo "Cleaning up test directories..."
  rm -rf "$TEST_DIR"

  # Also clean up the test configurations
  echo "Cleaning up test configurations..."
  rm -rf "$HOME/.config/gcloud-env/$CONFIG1"
  rm -rf "$HOME/.config/gcloud-env/$CONFIG2"

  echo "Done."
}

# Ensure cleanup happens even if the script is interrupted
trap cleanup EXIT INT TERM

# Setup test environment
setup() {
  echo "Setting up test environment..."

  # Clean up any existing test configurations
  rm -rf "$HOME/.config/gcloud-env/$CONFIG1"
  rm -rf "$HOME/.config/gcloud-env/$CONFIG2"

  # Create test directories
  mkdir -p "$PROJECT1_DIR" "$PROJECT2_DIR" "$PROJECT1_SUBDIR"

  # Source the gcloud-env script to enable auto-switching
  source "$GCLOUD_ENV_SCRIPT"

  echo "Test environment ready."
}

# Check if the current configuration matches the expected one
check_config() {
  local expected="$1"
  local current=$($GCLOUD_ENV_SCRIPT current | grep -o "$expected")
  
  if [[ "$current" == "$expected" ]]; then
    echo -e "${GREEN}PASSED${NC}: Current configuration is $expected as expected"
    return 0
  else
    echo -e "${RED}FAILED${NC}: Expected configuration to be $expected, but got $current"
    return 1
  fi
}

# Main test function
main() {
  # Setup
  setup

  # Change to project1 directory
  cd "$PROJECT1_DIR"
  echo "Changed to $PROJECT1_DIR"

  # Initialize first configuration
  $GCLOUD_ENV_SCRIPT init $CONFIG1
  echo "Initialized $CONFIG1 for project1"

  # Check current configuration
  check_config "$CONFIG1" || exit 1

  # Change to project2 directory
  cd "$PROJECT2_DIR"
  echo "Changed to $PROJECT2_DIR"

  # Initialize second configuration
  $GCLOUD_ENV_SCRIPT init $CONFIG2
  echo "Initialized $CONFIG2 for project2"

  # Check current configuration
  check_config "$CONFIG2" || exit 1

  # Change back to project1 directory - this should auto-switch to CONFIG1
  cd "$PROJECT1_DIR"
  echo "Changed back to $PROJECT1_DIR"

  # Check if configuration switched automatically
  check_config "$CONFIG1" || exit 1

  # Change to project1 subdirectory - this should still use CONFIG1
  cd "$PROJECT1_SUBDIR"
  echo "Changed to $PROJECT1_SUBDIR"

  # Check if configuration is still CONFIG1
  check_config "$CONFIG1" || exit 1

  # Change back to project2 directory - this should auto-switch to CONFIG2
  cd "$PROJECT2_DIR"
  echo "Changed back to $PROJECT2_DIR"

  # Check if configuration switched automatically
  check_config "$CONFIG2" || exit 1

  # All tests passed
  echo -e "\n${GREEN}All auto-switching tests passed!${NC}"

  # Clean up
  cleanup
}

# Run the tests
main