#!/usr/bin/env bash
set -euo pipefail

# Load configuration
source ./config.sh

echo "[BUILD] Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "[BUILD] Creating zip artifact..."
# -r for recursive
cd "$APP_DIR"
zip -r "../$BUILD_DIR/$ARTIFACT_NAME" .
cd ..

echo "[BUILD] Build complete. Artifact: $BUILD_DIR/$ARTIFACT_NAME"
