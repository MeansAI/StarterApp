#!/bin/bash
set -e
cd "$(dirname "$0")"

# Get component name from directory
COMPONENT_NAME=$(basename "$(pwd)")

BUILD_FILE="build_number.txt"
if [ -f "$BUILD_FILE" ]; then
    BUILD=$(($(cat "$BUILD_FILE") + 1))
else
    BUILD=1
fi
echo "$BUILD" > "$BUILD_FILE"

echo "Build #$BUILD"
swift build
