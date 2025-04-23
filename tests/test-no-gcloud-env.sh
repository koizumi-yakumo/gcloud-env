#!/usr/bin/env bash

# Test script for gcloud-env behavior when .gcloud-env doesn't exist
# This script tests that the cd command behaves normally when changing to a directory without .gcloud-env

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Path to the gcloud-env script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GCLOUD_ENV_SCRIPT="$SCRIPT_DIR/../bin/gcloud-env"

# Test directories
TEST_DIR="/tmp/gcloud-env-no-file-test"
PROJECT_DIR="$TEST_DIR/project"
NO_ENV_DIR="$TEST_DIR/no_env"

# Test configuration
CONFIG="test-no-env-config"

# Clean up function
cleanup() {
  echo "Cleaning up test directories..."
  rm -rf "$TEST_DIR"

  # Also clean up the test configuration
  echo "Cleaning up test configuration..."
  rm -rf "$HOME/.config/gcloud-env/$CONFIG"

  echo "Done."
}

# Ensure cleanup happens even if the script is interrupted
trap cleanup EXIT INT TERM

# Setup test environment
setup() {
  echo "Setting up test environment..."

  # Clean up any existing test configuration
  rm -rf "$HOME/.config/gcloud-env/$CONFIG"

  # Create test directories
  mkdir -p "$PROJECT_DIR" "$NO_ENV_DIR"

  # Source the gcloud-env script to enable auto-switching
  source "$GCLOUD_ENV_SCRIPT"

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
  $GCLOUD_ENV_SCRIPT init $CONFIG
  echo "Initialized $CONFIG for project"

  # Change to directory without .gcloud-env
  cd "$NO_ENV_DIR"
  echo "Changed to $NO_ENV_DIR"

  # If we got here without crashing, the test passed
  echo -e "${GREEN}PASSED${NC}: cd to directory without .gcloud-env didn't crash"

  # All tests passed
  echo -e "\n${GREEN}All tests passed!${NC}"

  # Clean up
  cleanup
}

# Run the tests
main