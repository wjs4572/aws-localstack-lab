#!/usr/bin/env bash
# Clean build artifacts

set -euo pipefail

# Load configuration
source ./config.sh

echo "[CLEAN] Removing build directory..."
rm -rf "$BUILD_DIR"

echo "[CLEAN] Build artifacts cleaned."
