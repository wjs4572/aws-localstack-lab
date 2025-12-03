#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build"
ARTIFACT_NAME="app.zip"

echo "[BUILD] Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "[BUILD] Creating zip artifact..."
# -r for recursive
cd app
zip -r "../$BUILD_DIR/$ARTIFACT_NAME" .
cd ..

echo "[BUILD] Build complete. Artifact: $BUILD_DIR/$ARTIFACT_NAME"
