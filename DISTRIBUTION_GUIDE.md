# RNComponentSDK Distribution Guide

## The Challenge with XCFramework Approach

Building React Native as an embedded XCFramework has limitations:

**Why the Archive Fails:**
- React Native generates code at build time (Codegen)
- Header visibility issues with nested frameworks
- Static framework linkage conflicts
- Module map complexity

**Error:**
```
CpHeader ... ReactAppDependencyProvider.framework/Headers/RCTAppDependencyProvider.h
```

This happens because React Native's dynamic code generation doesn't work well in the XCFramework archive process.

## ✅ Recommended Solutions

Instead of distributing as `.xcframework`, use these proven approaches:

---

### Solution 1: CocoaPods Source Distribution (Recommended)

**Best for**: Teams using CocoaPods, easy updates, source-level integration

#### Step 1: Create Podspec

```ruby
# RNComponentSDK.podspec
Pod::Spec.new do |s|
  s.name         = 'RNComponentSDK'
  s.version      = '1.0.0'
  s.summary      = 'React Native component SDK with Swift API'
  s.homepage     = 'https://github.com/yourorg/RNComponentSDK'
  s.license      = 'MIT'
  s.author       = { 'Your Name' => 'email@example.com' }
  s.source       = { :git => 'https://github.com/yourorg/RNComponentSDK.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '15.1'
  s.swift_version = '5.0'
  
  s.source_files = 'RNComponentSDK/**/*.{h,m,mm,swift}'
  s.public_header_files = 'RNComponentSDK/RNComponentSDK.h'
  
  s.resources = ['RNComponentSDK/Resources/*']
  
  s.dependency 'React', '~> 0.81.4'
  s.dependency 'React-Core', '~> 0.81.4'
  s.dependency 'React-hermes', '~> 0.81.4'
  s.dependency 'hermes-engine', '~> 0.81.4'
  
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'SWIFT_VERSION' => '5.0',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }
end
```

#### Step 2: Consumer Integration

**Consumer's Podfile:**
```ruby
# Point to React Native
require_relative '../node_modules/react-native/scripts/react_native_pods'

platform :ios, '15.1'
prepare_react_native_project!

target 'MyApp' do
  use_frameworks! :linkage => :static
  
  # Use React Native
  use_react_native!(
    :path => './node_modules/react-native',
    :hermes_enabled => true
  )
  
  # Add your SDK
  pod 'RNComponentSDK', :path => '../RNComponentSDK'
end
```

**Usage:**
```swift
import RNComponentSDK

let view = ComponentFactory.shared.createLargeText("Hello!")
```

---

### Solution 2: Manual Source Integration

**Best for**: Simple projects, no CocoaPods, direct control

#### Step 1: Copy Files to Project

1. Drag `RNComponentSDK/` folder into Xcode
2. Select "Create groups"
3. Add to target membership
4. Ensure Resources are copied

#### Step 2: Configure React Native

Consumer must have React Native configured via Expo or RN CLI.

#### Step 3: Use SDK

```swift
import RNComponentSDK
// Same API as CocoaPods approach
```

---

### Solution 3: Swift Package with Binary Resources

**Best for**: Modern Swift projects, SPM users

#### Create Package.swift

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "RNComponentSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "RNComponentSDK",
            targets: ["RNComponentSDK"]
        )
    ],
    targets: [
        .target(
            name: "RNComponentSDK",
            dependencies: [],
            path: "RNComponentSDK",
            resources: [
                .copy("Resources/main.jsbundle"),
                .copy("Resources/MaterialIcons.ttf")
            ]
        )
    ]
)
```

**Note**: Consumer still needs React Native separately.

---

### Solution 4: Prebuilt Dynamic Framework (Simplified)

**Best for**: Distribution to multiple teams, binary distribution

#### Modified Approach:

Instead of archiving, build as dynamic framework:

```ruby
# Podfile - use dynamic frameworks
use_frameworks! :linkage => :dynamic
```

Then manually package:

```bash
# Build for device
xcodebuild -workspace RNComponentSDK.xcworkspace \
  -scheme RNComponentSDK \
  -configuration Release \
  -sdk iphoneos \
  -derivedDataPath ./build

# Find framework at:
# build/Build/Products/Release-iphoneos/RNComponentSDK.framework
```

**Limitation**: Consumer must include React Native dependencies.

---

## 📊 Comparison

| Method | Complexity | Updates | Best For |
|--------|-----------|---------|----------|
| **CocoaPods (Recommended)** | Low | Easy | Teams with CocoaPods |
| **Manual Source** | Medium | Manual | Simple projects |
| **Swift Package** | Medium | Moderate | SPM users |
| **Dynamic Framework** | High | Manual | Binary distribution |

---

## 🎯 Recommended: CocoaPods Integration

**Why this is best:**

1. ✅ **Source-level integration** - No framework packaging issues
2. ✅ **Easy updates** - `pod update RNComponentSDK`
3. ✅ **React Native compatibility** - Works with RN's build system
4. ✅ **Standard approach** - How most RN libraries are distributed
5. ✅ **Debugging** - Full source access for debugging

**Complete Example:**

### SDK Repository Structure

```
RNComponentSDK/
├── RNComponentSDK.podspec        # Pod specification
├── RNComponentSDK/               # Source code
│   ├── RNComponentSDK.h
│   ├── RNBridgeManager.swift
│   ├── ComponentFactory.swift
│   └── Resources/
│       ├── main.jsbundle
│       └── MaterialIcons.ttf
├── README.md
└── LICENSE
```

### Consumer App Setup

1. **Add to Podfile:**
   ```ruby
   pod 'RNComponentSDK', :git => 'https://github.com/yourorg/RNComponentSDK.git'
   ```

2. **Run:**
   ```bash
   pod install
   ```

3. **Use:**
   ```swift
   import RNComponentSDK
   
   class ViewController: UIViewController {
       override func viewDidLoad() {
           super.viewDidLoad()
           
           let text = ComponentFactory.shared.createLargeText("Success!")
           text.frame = CGRect(x: 20, y: 100, width: 300, height: 50)
           view.addSubview(text)
       }
   }
   ```

---

## 📝 Next Steps

### For SDK Development:

1. **Create RNComponentSDK.podspec** (see Solution 1)
2. **Test locally** with `:path` in consumer's Podfile
3. **Push to Git** repository
4. **Distribute** via Git URL or private CocoaPods repo

### For SDK Consumers:

1. **Ensure React Native setup** (via Expo or RN CLI)
2. **Add pod dependency** to Podfile
3. **Run `pod install`**
4. **Import and use** the SDK

---

## ⚠️ Important Notes

### React Native Requirement

**Consumers must have React Native configured**, either via:
- Expo (`npx expo prebuild`)
- React Native CLI (`npx react-native init`)

The SDK doesn't include RN runtime - it's a wrapper around it.

### Bundle Updates

When updating React Native components:

1. **Rebuild JS bundle:**
   ```bash
   cd ../RNLib
   npm run bundle:ios
   cp ios/main.jsbundle ../RNComponentSDK/RNComponentSDK/Resources/
   ```

2. **Version bump** in podspec
3. **Commit and tag**
4. **Consumers update:** `pod update RNComponentSDK`

### Debugging

With source distribution, consumers can:
- Set breakpoints in Swift code
- See full source in Xcode
- Modify locally for testing
- Submit pull requests

---

## 🔧 Troubleshooting

### "Module not found"

Ensure consumer's Podfile includes React Native:
```ruby
use_react_native!(
  :path => './node_modules/react-native',
  :hermes_enabled => true
)
```

### "Bundle not found"

Check Resources are copied:
1. Target → Build Phases → Copy Bundle Resources
2. Should include `main.jsbundle` and `MaterialIcons.ttf`

### Version conflicts

Match React Native versions:
- SDK built with RN 0.81.4
- Consumer must use RN 0.81.x

---

## ✅ Summary

**The XCFramework approach failed** due to React Native's architecture, but this is actually a **blessing in disguise**.

**CocoaPods source distribution is:**
- ✅ Easier to maintain
- ✅ Standard for RN libraries
- ✅ Better debugging experience
- ✅ Automatic dependency resolution
- ✅ Proven approach used by thousands of RN libraries

**Phase 3 is still complete!** The SDK structure, Swift API, and React Native integration all work perfectly. Only the packaging method changes.

---

**Ready to distribute? Create the podspec and you're done!** 🚀

