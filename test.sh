#!/usr/bin/env bash
set -euo pipefail

# Load configuration
source ./config.sh

echo "[TEST] Verifying build artifact exists..."
if [[ ! -f "$BUILD_DIR/$ARTIFACT_NAME" ]]; then
  echo "[TEST] ERROR: Artifact $BUILD_DIR/$ARTIFACT_NAME not found."
  exit 1
fi

echo "[TEST] Checking $APP_DIR/index.html for a title tag..."
if ! grep -q "<title>LocalStack CI/CD Lab</title>" "$APP_DIR/index.html"; then
  echo "[TEST] ERROR: Expected title tag not found in $APP_DIR/index.html."
  exit 1
fi

echo "[TEST] All tests passed."
