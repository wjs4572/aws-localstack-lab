#!/usr/bin/env bash
set -euo pipefail

BUILD_DIR="build"
ARTIFACT_NAME="app.zip"

echo "[TEST] Verifying build artifact exists..."
if [[ ! -f "$BUILD_DIR/$ARTIFACT_NAME" ]]; then
  echo "[TEST] ERROR: Artifact $BUILD_DIR/$ARTIFACT_NAME not found."
  exit 1
fi

echo "[TEST] Checking app/index.html for a title tag..."
if ! grep -q "<title>LocalStack CI/CD Lab</title>" app/index.html; then
  echo "[TEST] ERROR: Expected title tag not found in app/index.html."
  exit 1
fi

echo "[TEST] All tests passed."
