#!/bin/bash
set -e
cd "$(dirname "$0")"

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

# Get app name from directory
APP_NAME=$(basename "$(pwd)")

BUILD_FILE="build_number.txt"
if [ -f "$BUILD_FILE" ]; then
    BUILD=$(($(cat "$BUILD_FILE") + 1))
else
    BUILD=1
fi
echo "$BUILD" > "$BUILD_FILE"

sed -i '' "s/CURRENT_PROJECT_VERSION: \"[0-9]*\"/CURRENT_PROJECT_VERSION: \"$BUILD\"/" project.yml

echo "Build #$BUILD"
xcodegen generate
xcodebuild -project ${APP_NAME}.xcodeproj -scheme ${APP_NAME} -configuration Debug build | xcpretty || xcodebuild -project ${APP_NAME}.xcodeproj -scheme ${APP_NAME} -configuration Debug build | tail -20

# Launch the app if requested
if [ "$RUN_AFTER_BUILD" = true ]; then
    echo ""
    echo "Launching ${APP_NAME}..."
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "${APP_NAME}.app" -path "*/Build/Products/Debug/*" -type d 2>/dev/null | head -1)
    if [ -n "$APP_PATH" ]; then
        open "$APP_PATH"
        echo "Launched: $APP_PATH"
    else
        echo "Could not find built app to launch"
    fi
fi
