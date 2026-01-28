# StarterApp - Agent Instructions

## Project Structure

```
StarterApp/
├── StarterApp/          # iOS/macOS app (XcodeGen)
├── StarterBridge/       # Shared DTOs (Swift Package)
└── StarterServer/       # Vapor backend (Swift Package)
```

## Build Commands

### Build Everything
```bash
./build.sh
```

### Build Individual Components
```bash
cd StarterBridge && ./build.sh   # Shared DTOs
cd StarterApp && ./build.sh      # Client app
cd StarterServer && ./build.sh   # Server
```

Each build script:
1. Auto-increments build number in `build_number.txt`
2. Runs the appropriate build command

## Running

### Client App
```bash
cd StarterApp && ./build.sh
open /Users/justinmeans/Library/Developer/Xcode/DerivedData/StarterApp-*/Build/Products/Debug/StarterApp.app
```

### Server
```bash
cd StarterServer && swift run
```

Environment variables for server:
- `DATABASE_URL` or individual DB vars
- `DISABLE_SSL=true` for local dev

## Architecture

### JWS Platform Stack
- **JCX** - Core extensions (macros, collections, algorithms)
- **JUI** - UI components and styling
- **JBS** - Business logic and DTOs
- **JCS** - Client services (routing, auth, network)
- **JWS** - Server framework (Vapor-based)
- **StarterBridge** - Shared DTOs between client/server

### Component Responsibilities
- **StarterApp** - iOS/macOS client, UI, user interaction
- **StarterBridge** - User, AuthDevice DTOs shared by client and server
- **StarterServer** - API endpoints, database, authentication

## Code Style

- Swift 6 with strict concurrency
- NO comments unless absolutely necessary
- NO dictionary subscripts - use Codable DTOs
- Use JUI spacing: `.xSmall`, `.small`, `.medium`, `.large`, `.xLarge`
- Use JUI fonts: `.lunaFont(.body)`, `.lunaFont(.headline, weight: .bold)`

## Adding Features

### New API Endpoint
1. Add DTO to StarterBridge if needed
2. Add route in StarterServer module
3. Add client method in StarterApp/Network.swift

### New Route (Client)
1. Add case to `Interface.Routes` in Engine.swift
2. Add view to ContentView.swift with `.jTag()`
3. Add button to BottomBarView if needed

## Project Management

**CRITICAL: Never edit `.xcodeproj` files directly.**

StarterApp uses XcodeGen - all config in `project.yml`.
StarterBridge and StarterServer are pure Swift Packages.
