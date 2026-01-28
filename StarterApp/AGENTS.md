# StarterApp - Agent Instructions

## Project Structure

```
StarterApp/
├── StarterApp/          # iOS/macOS app (XcodeGen)
├── StarterBridge/       # Shared DTOs (Swift Package)
└── StarterServer/       # Vapor backend (Swift Package)
```

## Build Process

**ALWAYS use the build script** - never run xcodebuild directly:

```bash
cd StarterApp
./build.sh
```

This script:
1. Auto-increments the build number in `build_number.txt`
2. Updates `project.yml` with the new build number
3. Runs `xcodegen generate` to create the Xcode project
4. Runs `xcodebuild` to compile

## Project Management

**CRITICAL: Never edit `.xcodeproj` files directly.**

- All project configuration lives in `project.yml`
- Use XcodeGen to regenerate the project: `xcodegen generate`
- The `.xcodeproj` is generated output, not source

## Running the App

After building:
```bash
open /Users/justinmeans/Library/Developer/Xcode/DerivedData/StarterApp-*/Build/Products/Debug/StarterApp.app
```

## Architecture

### JWS Platform Stack
This app is built on the JWS (Justin's Web Services) platform:

- **JCX** - Core extensions (macros, collections, algorithms, async)
- **JUI** - UI components and styling (lunaFont, Fibonacci spacing, etc.)
- **JBS** - Business logic and DTOs (User models, auth, websockets)
- **JCS** - Common services for clients (routing, auth, network, persistence)
- **JWS** - Server-side framework (Vapor-based, auth, modules)
- **StarterBridge** - Shared DTOs between client and server

### StarterApp (Client)
- `StarterAppApp.swift` - Main entry point, AppDelegate, environment setup
- `Engine.swift` - Interface class (routing, colors, styles)
- `Network.swift` - Network class (API, auth, persistence)
- `ContentView.swift` - Main view with JCS modifier stack

### StarterBridge (Shared DTOs)
- `User.swift` - User model (Micro, Global, Personal, CreateData, Put)
- `AuthDevice.swift` - Device authentication model
- Shared between client app and server

### StarterServer (Backend)
- `configure.swift` - Server configuration and module registration
- `Modules/User/` - User authentication module
- `Modules/Moderate/` - Content moderation module

### JCS Modifier Stack (ORDER MATTERS)
1. `JCSBottomBar` - Bottom navigation
2. `GaiaTopBar` - Top bar with logo, loader, command menu
3. `JCSMain` - Modal handling, overlays
4. Background - Must be last with edgesIgnoringSafeArea

### Routing
Routes are defined in `Interface.Routes` enum. Each route has:
- `title` - Display title
- `icon` - SF Symbol name
- `navigationMask` - Back button behavior
- `navigationUIMode` - Top/bottom bar visibility
- `jTag` - Animation tag for transitions

## Code Style

- Swift 6 with strict concurrency
- NO comments unless absolutely necessary
- NO dictionary subscripts - use Codable DTOs
- NO backwards compatibility code
- Use JUI spacing: `.xSmall`, `.small`, `.medium`, `.large`, `.xLarge`
- Use JUI fonts: `.lunaFont(.body)`, `.lunaFont(.headline, weight: .bold)`

## Dependencies

### StarterApp (project.yml)
- JUI - UI components and styling
- JCX - Core extensions
- JBS - Business logic and DTOs
- JCS - Common services
- StarterBridge - Shared DTOs

### StarterBridge (Package.swift)
- JBS - Base DTOs and protocols

### StarterServer (Package.swift)
- JWS - Server framework
- StarterBridge - Shared DTOs

## Adding New Routes

1. Add case to `Interface.Routes` in Engine.swift
2. Implement `title`, `icon`, `navigationMask`, `navigationUIMode`
3. Add view to ContentView.swift with `.jTag()`
4. Add button to BottomBarView if needed

## Adding API Endpoints

1. Configure `apiBase` in Network.swift (client)
2. Add route in StarterServer module controller
3. Add shared DTOs in StarterBridge
4. Add client method in Network.swift

## Running the Server

```bash
cd StarterServer
swift run
```

Environment variables needed:
- `DATABASE_URL` or `DATABASE_HOST`, `DATABASE_PORT`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`, `DATABASE_NAME`
- `DISABLE_SSL=true` for local development

## iOS Device Deployment (CLI - No Xcode GUI)

### List Connected Devices

```bash
xcrun devicectl list devices
```

### Build for iOS Device

```bash
cd StarterApp
xcodegen generate
xcodebuild -scheme StarterApp-iOS \
  -destination 'id=DEVICE_IDENTIFIER' \
  -configuration Debug \
  -skipMacroValidation \
  -skipPackageSignatureValidation \
  -allowProvisioningUpdates \
  build
```

### Install & Launch on Device

```bash
# Install
xcrun devicectl device install app \
  --device DEVICE_IDENTIFIER \
  ~/Library/Developer/Xcode/DerivedData/StarterApp-*/Build/Products/Debug-iphoneos/StarterApp-iOS.app

# Launch
xcrun devicectl device process launch \
  --device DEVICE_IDENTIFIER \
  com.outtakes.starterapp
```

### Required project.yml Settings

```yaml
settings:
  base:
    DEVELOPMENT_TEAM: "PASKH93M73"  # Outtakes LLC
```
