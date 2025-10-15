# Xcode Project Setup Guide

Step-by-step instructions for setting up the RNComponentSDK Xcode project.

## Quick Reference

The framework project has been created with the following structure:

```
RNComponentSDK/
├── RNComponentSDK.xcodeproj/     # Xcode project file
│   └── project.pbxproj           # Project configuration
├── RNComponentSDK.xcworkspace/   # CocoaPods workspace (created after pod install)
├── RNComponentSDK/               # Framework source
│   ├── RNComponentSDK.h          # Umbrella header (public)
│   ├── Info.plist                # Framework metadata
│   ├── RNBridgeManager.swift     # Bridge manager (internal)
│   ├── ComponentFactory.swift    # Public API
│   └── Resources/
│       ├── main.jsbundle         # JavaScript bundle
│       └── MaterialIcons.ttf     # Icon font
├── Podfile                       # CocoaPods dependencies
├── build-framework.sh            # Build script
├── README.md                     # Main documentation
├── INTEGRATION_GUIDE.md          # Integration guide
└── XCODE_SETUP.md                # This file
```

## Setup Steps

### 1. Install CocoaPods Dependencies

```bash
cd RNComponentSDK
export LANG=en_US.UTF-8
pod install
```

**Expected Output:**
```
Analyzing dependencies
Downloading dependencies
Installing React-Core (0.81.4)
...
Pod installation complete!
```

### 2. Open Workspace in Xcode

⚠️ **Important**: Always use the `.xcworkspace`, not `.xcodeproj`

```bash
open RNComponentSDK.xcworkspace
```

### 3. Verify Project Settings

In Xcode, select the **RNComponentSDK** target and verify:

#### General Tab
- **Display Name**: RNComponentSDK
- **Bundle Identifier**: com.example.RNComponentSDK
- **Version**: 1.0
- **Minimum Deployments**: iOS 13.0

#### Build Settings
- **iOS Deployment Target**: 13.0
- **Build Library for Distribution**: YES
- **Swift Language Version**: Swift 5
- **Enable Bitcode**: NO

#### Build Phases

1. **Headers** (Public)
   - RNComponentSDK.h

2. **Sources**
   - RNBridgeManager.swift
   - ComponentFactory.swift

3. **Resources**
   - main.jsbundle
   - MaterialIcons.ttf

4. **Frameworks**
   - React Native frameworks (via CocoaPods)

### 4. Build the Framework

#### Option A: Command Line (Recommended)

```bash
./build-framework.sh
```

This script:
1. Cleans previous builds
2. Installs CocoaPods if needed
3. Builds for iOS Simulator (arm64 + x86_64)
4. Builds for iOS Device (arm64)
5. Creates XCFramework combining both
6. Outputs to `build/RNComponentSDK.xcframework`

#### Option B: Manual Xcode Build

1. Select **RNComponentSDK** scheme
2. Choose destination:
   - "Any iOS Device (arm64)" for device build
   - "Any iOS Simulator" for simulator build
3. **Product → Build** (⌘+B)

The framework will be in:
```
~/Library/Developer/Xcode/DerivedData/RNComponentSDK-*/Build/Products/Release-iphoneos/RNComponentSDK.framework
```

## File Details

### RNComponentSDK.h

The umbrella header. Must be set to **Public** in Build Phases → Headers.

```objc
#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double RNComponentSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char RNComponentSDKVersionString[];
```

### Info.plist

Framework metadata and font configuration:

```xml
<key>CFBundleExecutable</key>
<string>$(EXECUTABLE_NAME)</string>
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
<key>UIAppFonts</key>
<array>
    <string>MaterialIcons.ttf</string>
</array>
```

### RNBridgeManager.swift

Manages the React Native bridge lifecycle:
- Singleton pattern
- Loads JS bundle from framework resources
- Initializes RCTBridge
- Provides bridge access to ComponentFactory

Key methods:
```swift
func initializeBridge() -> Bool
func getBridge() -> RCTBridge?
func reloadBridge()
func invalidateBridge()
```

### ComponentFactory.swift

Public API for the framework:
- Singleton pattern
- Creates React Native components as UIViews
- Provides async data fetching

Public methods:
```swift
func createSmallText(_ text: String) -> UIView
func createLargeText(_ text: String) -> UIView
func fetchStringArray(completion: @escaping ([String]?, Error?) -> Void)
func fetchStringArray() async throws -> [String]  // iOS 13+
```

### Podfile

Specifies React Native dependencies:
- Points to local node_modules
- Includes all necessary React Native pods
- Configured for framework build (not app)
- Sets minimum iOS version to 13.0
- Enables BUILD_LIBRARY_FOR_DISTRIBUTION

Key pods:
- React-Core
- React-RCTText
- React-RCTImage  
- hermes-engine
- Yoga (layout)

## Adding Resources

### JavaScript Bundle

The bundle must be rebuilt whenever React Native components change:

```bash
cd ../RNLib
npm run bundle:ios
cp ios/main.jsbundle ../RNComponentSDK/RNComponentSDK/Resources/
```

### Fonts

To add more fonts:

1. Copy font file to `RNComponentSDK/Resources/`
2. Add to Xcode project (Target Membership: RNComponentSDK)
3. Update `Info.plist`:
   ```xml
   <key>UIAppFonts</key>
   <array>
       <string>MaterialIcons.ttf</string>
       <string>YourNewFont.ttf</string>
   </array>
   ```

## Troubleshooting

### Pod install fails with encoding error

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
pod install
```

### Xcode can't find headers

1. Clean build folder: **Product → Clean Build Folder** (⌘+Shift+K)
2. Close Xcode
3. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/RNComponentSDK-*
   ```
4. Reopen workspace:
   ```bash
   open RNComponentSDK.xcworkspace
   ```

### Framework not embedding resources

1. Select target → **Build Phases**
2. Verify **Copy Bundle Resources** includes:
   - main.jsbundle
   - MaterialIcons.ttf
3. If missing, add them manually:
   - Click **+**
   - Select files from RNComponentSDK/Resources/

### Swift module not found in consumer app

Ensure the framework is set to **"Embed & Sign"** in the consumer app:
1. Select app target
2. **General** → **Frameworks, Libraries, and Embedded Content**
3. Set RNComponentSDK.xcframework to **"Embed & Sign"**

### Build fails with duplicate symbols

This usually means React Native is also in the consumer app. Solutions:

1. **Option A**: Remove React Native from consumer app (use only framework version)
2. **Option B**: Use dynamic framework instead of static
3. **Option C**: Configure proper import paths

## Advanced Configuration

### Changing Bundle Identifier

In Xcode:
1. Select RNComponentSDK target
2. **General** → **Identity** → **Bundle Identifier**
3. Change from `com.example.RNComponentSDK` to your identifier

### Adding New Swift Files

1. **File → New → File** (⌘+N)
2. Choose **Swift File**
3. Ensure **Target Membership** includes RNComponentSDK
4. If public API, add to `RNComponentSDK.h` if needed

### Debug Logging

To enable React Native logging:

```swift
// In RNBridgeManager.swift
private func initializeBridge() -> Bool {
    RCTSetLogThreshold(RCTLogLevel.trace)  // Add this line
    // ... rest of initialization
}
```

### Custom Build Configurations

1. Select project in navigator
2. **Info** → **Configurations**
3. Duplicate **Debug** or **Release**
4. Customize build settings for new configuration

## Testing the Framework

### Unit Tests (Optional)

Create a test target:
1. **File → New → Target**
2. Choose **Unit Testing Bundle**
3. Name: RNComponentSDKTests
4. Link against RNComponentSDK.framework

### Integration Testing

Create a simple iOS app:
1. Create new iOS App project
2. Add RNComponentSDK.xcframework
3. Test basic functionality:

```swift
import RNComponentSDK

let view = ComponentFactory.shared.createSmallText("Test")
assert(view.subviews.count > 0, "Component should have content")
```

## Building for Distribution

### App Store

1. Build with **Release** configuration
2. Use build script: `./build-framework.sh`
3. Distribute `RNComponentSDK.xcframework`

### XCFramework Benefits

- ✅ Supports both Simulator and Device
- ✅ Supports all architectures (arm64, x86_64)
- ✅ Single artifact for distribution
- ✅ Better than fat binary (.framework with lipo)

### Versioning

Update version in two places:

1. **Info.plist**:
   ```xml
   <key>CFBundleShortVersionString</key>
   <string>1.0.0</string>
   ```

2. **README.md**: Update version number

## Next Steps

1. ✅ Project setup complete
2. ✅ Build framework: `./build-framework.sh`
3. ✅ Test in demo app (see INTEGRATION_GUIDE.md)
4. ✅ Distribute to consumers

---

**Questions?** Check README.md or INTEGRATION_GUIDE.md for more details.

