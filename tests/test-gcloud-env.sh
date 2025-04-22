#!/usr/bin/env bash

# Test script for gcloud-env
# This script tests the basic functionality of gcloud-env

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Path to the gcloud-env script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GCLOUD_ENV_SCRIPT="$SCRIPT_DIR/../bin/gcloud-env.sh"

# Test directories
TEST_DIR="/tmp/gcloud-env-test"
PROJECT1_DIR="$TEST_DIR/project1"
PROJECT2_DIR="$TEST_DIR/project2"

# Test configurations
CONFIG1="test-config1"
CONFIG2="test-config2"

# Clean up function
cleanup() {
  echo "Cleaning up test directories..."
  rm -rf "$TEST_DIR"
  echo "Done."
}

# Run a test and check the result
run_test() {
  local test_name="$1"
  local command="$2"
  local expected_output="$3"
  
  echo -n "Testing $test_name... "
  
  # Run the command and capture output
  local output
  output=$($command 2>&1) || {
    echo -e "${RED}FAILED${NC}"
    echo "Command failed: $command"
    echo "Output: $output"
    cleanup
    exit 1
  }
  
  # Check if output contains expected string
  if [[ "$output" == *"$expected_output"* ]]; then
    echo -e "${GREEN}PASSED${NC}"
  else
    echo -e "${RED}FAILED${NC}"
    echo "Expected output to contain: $expected_output"
    echo "Actual output: $output"
    cleanup
    exit 1
  fi
}

# Setup test environment
setup() {
  echo "Setting up test environment..."
  
  # Create test directories
  mkdir -p "$PROJECT1_DIR" "$PROJECT2_DIR"
  
  # Source the gcloud-env script
  source "$GCLOUD_ENV_SCRIPT"
  
  echo "Test environment ready."
}

# Main test function
main() {
  # Setup
  setup
  
  # Change to project1 directory
  cd "$PROJECT1_DIR"
  
  # Test 1: Initialize first configuration
  run_test "init command for project1" \
    "bash $GCLOUD_ENV_SCRIPT init $CONFIG1" \
    "Initialized new"
  
  # Test 2: Check current configuration
  run_test "current command after init" \
    "bash $GCLOUD_ENV_SCRIPT current" \
    "Current gcloud configuration: $CONFIG1"
  
  # Change to project2 directory
  cd "$PROJECT2_DIR"
  
  # Test 3: Initialize second configuration
  run_test "init command for project2" \
    "bash $GCLOUD_ENV_SCRIPT init $CONFIG2" \
    "Initialized new"
  
  # Test 4: Check current configuration
  run_test "current command after second init" \
    "bash $GCLOUD_ENV_SCRIPT current" \
    "Current gcloud configuration: $CONFIG2"
  
  # Test 5: List configurations
  run_test "list command" \
    "bash $GCLOUD_ENV_SCRIPT list" \
    "$CONFIG2"
  
  # Change back to project1 directory
  cd "$PROJECT1_DIR"
  
  # Test 6: Check if configuration switched automatically
  # Note: This will only work if the hook is set up, which it isn't in this test
  # So we'll manually use the configuration
  run_test "use command" \
    "bash $GCLOUD_ENV_SCRIPT use $CONFIG1" \
    "Switched to gcloud configuration: $CONFIG1"
  
  # Test 7: Check current configuration again
  run_test "current command after switching back" \
    "bash $GCLOUD_ENV_SCRIPT current" \
    "Current gcloud configuration: $CONFIG1"
  
  # All tests passed
  echo -e "\n${GREEN}All tests passed!${NC}"
  
  # Clean up
  cleanup
}

# Run the tests
main