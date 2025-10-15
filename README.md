# RNComponentSDK

**A native iOS framework wrapper for React Native components**

RNComponentSDK is a pure iOS Framework that provides native Swift APIs for UI components powered by React Native. It completely hides the React Native implementation, giving you clean, type-safe Swift interfaces.

## 🌟 Features

- ✅ **Pure Native API**: Clean Swift interfaces, no React Native knowledge required
- ✅ **Type-Safe**: Full Swift type safety with completion handlers and async/await
- ✅ **Self-Contained**: All dependencies bundled within the framework
- ✅ **Zero Configuration**: Works out of the box, no setup required
- ✅ **Universal**: Supports both iOS Simulator and Device (arm64, x86_64)

## 📦 What's Included

### Components

1. **SmallTextComponent**: Display text in 14pt font
2. **LargeTextComponent**: Display text in 24pt bold with a check icon
3. **AsyncStringArrayProvider**: Fetch string arrays asynchronously

### APIs

```swift
// Singleton instance
ComponentFactory.shared

// Create components
func createSmallText(_ text: String) -> UIView
func createLargeText(_ text: String) -> UIView

// Fetch data (callback)
func fetchStringArray(completion: @escaping ([String]?, Error?) -> Void)

// Fetch data (async/await)
func fetchStringArray() async throws -> [String]  // iOS 13+
```

## 🚀 Quick Start

### 1. Add to Podfile

```ruby
# In your app's Podfile
pod 'RNComponentSDK', :path => '../RNComponentSDK'
# Or from Git:
# pod 'RNComponentSDK', :git => 'https://github.com/yourorg/RNComponentSDK.git'
```

### 2. Install

```bash
pod install
```

### 3. Use in Your Code

```swift
import RNComponentSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a small text view
        let smallText = ComponentFactory.shared.createSmallText("Hello, World!")
        smallText.frame = CGRect(x: 20, y: 100, width: 300, height: 30)
        view.addSubview(smallText)
        
        // Create a large text view with icon
        let largeText = ComponentFactory.shared.createLargeText("Welcome!")
        largeText.frame = CGRect(x: 20, y: 150, width: 300, height: 40)
        view.addSubview(largeText)
        
        // Fetch data (callback style)
        ComponentFactory.shared.fetchStringArray { items, error in
            if let items = items {
                print("Received: \\(items)")
            }
        }
        
        // Fetch data (async/await style - iOS 13+)
        Task {
            do {
                let items = try await ComponentFactory.shared.fetchStringArray()
                print("Received: \\(items)")
            } catch {
                print("Error: \\(error)")
            }
        }
    }
}
```

## 📐 Architecture

### Directory Structure

```
RNComponentSDK/
├── RNComponentSDK/
│   ├── RNComponentSDK.h          # Umbrella header
│   ├── Info.plist                # Framework metadata
│   ├── RNBridgeManager.swift     # React Native bridge manager
│   ├── ComponentFactory.swift    # Public API
│   └── Resources/
│       ├── main.jsbundle         # JavaScript bundle
│       └── MaterialIcons.ttf     # Icon font
├── Podfile                       # CocoaPods dependencies
├── build-framework.sh            # Build script
└── README.md
```

### How It Works

1. **JavaScript Bundle**: React Native components are pre-compiled into `main.jsbundle`
2. **Bridge Manager**: `RNBridgeManager` initializes and manages the React Native bridge
3. **Component Factory**: `ComponentFactory` provides clean Swift APIs using `RCTRootView`
4. **Resource Embedding**: Bundle and fonts are embedded in the framework's resources

## 🔧 Development

### Prerequisites

- Xcode 14.0+
- iOS 13.0+ deployment target
- CocoaPods
- Node.js 20+ (for building JavaScript bundle)

### Building from Source

```bash
# 1. Build JavaScript bundle
cd ../RNLib
npm run bundle:ios

# 2. Copy bundle and fonts
cp ios/main.jsbundle ../RNComponentSDK/RNComponentSDK/Resources/
cp <path-to-font>/MaterialIcons.ttf ../RNComponentSDK/RNComponentSDK/Resources/

# 3. Install CocoaPods
cd ../RNComponentSDK
pod install

# 4. Build framework
./build-framework.sh
```

### Manual Xcode Build

If you prefer to build manually:

```bash
# Open workspace (not .xcodeproj!)
open RNComponentSDK.xcworkspace

# In Xcode:
# 1. Select RNComponentSDK scheme
# 2. Choose "Any iOS Device (arm64)" destination
# 3. Product → Archive
```

## 🎯 API Reference

### ComponentFactory

The main entry point for all framework functionality.

#### Properties

```swift
static let shared: ComponentFactory  // Singleton instance
```

#### Methods

##### createSmallText(_:)

Creates a view with 14pt text.

```swift
func createSmallText(_ text: String) -> UIView
```

**Parameters:**
- `text`: The text to display

**Returns:** A `UIView` containing the React Native component

**Example:**
```swift
let view = ComponentFactory.shared.createSmallText("Hello")
view.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
parentView.addSubview(view)
```

##### createLargeText(_:)

Creates a view with 24pt bold text and a check icon.

```swift
func createLargeText(_ text: String) -> UIView
```

**Parameters:**
- `text`: The text to display

**Returns:** A `UIView` containing the React Native component

**Example:**
```swift
let view = ComponentFactory.shared.createLargeText("Success!")
view.frame = CGRect(x: 0, y: 0, width: 250, height: 40)
parentView.addSubview(view)
```

##### fetchStringArray(completion:)

Fetches an array of strings asynchronously (callback style).

```swift
func fetchStringArray(completion: @escaping ([String]?, Error?) -> Void)
```

**Parameters:**
- `completion`: Callback with result or error

**Example:**
```swift
ComponentFactory.shared.fetchStringArray { items, error in
    guard let items = items else {
        print("Error: \\(error?.localizedDescription ?? "Unknown")")
        return
    }
    print("Items: \\(items)")
}
```

##### fetchStringArray() async throws

Fetches an array of strings asynchronously (async/await style).

```swift
func fetchStringArray() async throws -> [String]
```

**Returns:** Array of strings

**Throws:** `Error` if the operation fails

**Example:**
```swift
Task {
    do {
        let items = try await ComponentFactory.shared.fetchStringArray()
        updateUI(with: items)
    } catch {
        showError(error)
    }
}
```

### RNBridgeManager

Low-level bridge management (typically not used directly).

```swift
static let shared: RNBridgeManager    // Singleton
func initializeBridge() -> Bool       // Initialize React Native
func getBridge() -> RCTBridge?        // Get bridge instance
func reloadBridge()                   // Reload (development)
func invalidateBridge()               // Cleanup
```

## 🐛 Troubleshooting

### "Bundle not found" error

Ensure `main.jsbundle` is in the framework's Resources:
```bash
ls RNComponentSDK/Resources/main.jsbundle
```

### Icons not displaying

Ensure `MaterialIcons.ttf` is in Resources and listed in `Info.plist`:
```xml
<key>UIAppFonts</key>
<array>
    <string>MaterialIcons.ttf</string>
</array>
```

### Build errors with CocoaPods

Clean and reinstall:
```bash
rm -rf Pods Podfile.lock
pod install
```

### Components not rendering

Check bridge initialization:
```swift
let isReady = RNBridgeManager.shared.initializeBridge()
print("Bridge ready: \\(isReady)")
```

## 📄 License

MIT License - See LICENSE file for details

## 🤝 Contributing

This SDK is part of the todolistsdk project. See main repository for contribution guidelines.

## 📞 Support

For issues, questions, or feature requests, please open an issue in the main repository.

---

**Built with ❤️ using React Native + Swift**

