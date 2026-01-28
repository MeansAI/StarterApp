#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"

# Parse arguments
RUN_AFTER_BUILD=false
for arg in "$@"; do
    case $arg in
        --run|-r)
            RUN_AFTER_BUILD=true
            shift
            ;;
    esac
done

# Get app name from root directory (e.g., "StarterApp" -> base is "Starter")
ROOT_NAME=$(basename "$ROOT")

# Detect the actual directory names (handles both StarterApp/StarterBridge pattern and NewApp/NewAppBridge pattern)
if [ -d "$ROOT/${ROOT_NAME}Bridge" ]; then
    # Pattern: MyApp/MyAppBridge
    BRIDGE_DIR="${ROOT_NAME}Bridge"
    APP_DIR="${ROOT_NAME}"
    SERVER_DIR="${ROOT_NAME}Server"
elif [ -d "$ROOT/$(echo $ROOT_NAME | sed 's/App$//')Bridge" ]; then
    # Pattern: StarterApp/StarterBridge (App suffix stripped for Bridge/Server)
    BASE_NAME=$(echo $ROOT_NAME | sed 's/App$//')
    BRIDGE_DIR="${BASE_NAME}Bridge"
    APP_DIR="${ROOT_NAME}"
    SERVER_DIR="${BASE_NAME}Server"
else
    # Fallback: look for directories ending in Bridge/Server
    BRIDGE_DIR=$(ls -d */ 2>/dev/null | grep -E "Bridge/?$" | head -1 | tr -d '/')
    SERVER_DIR=$(ls -d */ 2>/dev/null | grep -E "Server/?$" | head -1 | tr -d '/')
    APP_DIR=$(ls -d */ 2>/dev/null | grep -vE "(Bridge|Server)/?$" | head -1 | tr -d '/')
fi

echo "=== Building $BRIDGE_DIR ==="
"$ROOT/$BRIDGE_DIR/build.sh"

echo ""
echo "=== Building $APP_DIR ==="
if [ "$RUN_AFTER_BUILD" = true ]; then
    "$ROOT/$APP_DIR/build.sh" --run
else
    "$ROOT/$APP_DIR/build.sh"
fi

echo ""
echo "=== Building $SERVER_DIR ==="
"$ROOT/$SERVER_DIR/build.sh"

echo ""
echo "=== All builds complete ==="

if [ "$RUN_AFTER_BUILD" = true ]; then
    echo "=== $APP_DIR is now running ==="
fi
