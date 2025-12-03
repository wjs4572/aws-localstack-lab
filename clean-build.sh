#!/usr/bin/env bash
# Clean build artifacts

set -euo pipefail

BUILD_DIR="build"

echo "[CLEAN] Removing build directory..."
rm -rf "$BUILD_DIR"

echo "[CLEAN] Build artifacts cleaned."
