# RNComponentSDK

A native iOS SDK that wraps React Native components with a clean Swift API. Build beautiful UI components using React Native, expose them through type-safe Swift interfaces.

## Features

- ✅ **Clean Swift API**: Simple, type-safe interfaces - no React Native knowledge required
- ✅ **Self-Contained**: All dependencies and resources bundled
- ✅ **Async/Await Support**: Modern Swift concurrency (iOS 13+)
- ✅ **CocoaPods Ready**: Easy installation via Git or local path

## Installation

### Prerequisites

- iOS 15.1+
- Xcode 14.0+
- CocoaPods
- **React Native 0.81.x** (required)

### Why React Native is Required

This SDK wraps React Native components. React Native CocoaPods integration requires the consumer to install React Native via npm - it's not available on CocoaPods trunk.

### Step 1: Install React Native

In your iOS app project root:

```bash
# Initialize package.json if you don't have one
npm init -y

# Install React Native
npm install react-native@0.81.4
```

### Step 2: Configure Podfile

```ruby
# Load React Native CocoaPods helper
require File.join(File.dirname(`node --print "require.resolve('react-native/package.json')"`), "scripts/react_native_pods")

platform :ios, '15.1'
prepare_react_native_project!

target 'YourApp' do
  use_frameworks! :linkage => :static
  
  # React Native (provides the runtime for RNComponentSDK)
  use_react_native!(
    :path => './node_modules/react-native',
    :hermes_enabled => true,
    :app_path => "#{Dir.pwd}"
  )
  
  # RNComponentSDK
  pod 'RNComponentSDK', 
      :git => 'https://github.com/maxim-drobonoh/RNComponentSDK.git'
end

post_install do |installer|
  react_native_post_install(installer, './node_modules/react-native')
end
```

### Step 3: Install Pods

```bash
pod install
```

### Step 4: Open Workspace

```bash
open YourApp.xcworkspace
```

## Usage

### Basic Example

```swift
import UIKit
import RNComponentSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a small text view (14pt)
        let smallText = ComponentFactory.shared.createSmallText("Hello, World!")
        smallText.frame = CGRect(x: 20, y: 100, width: 300, height: 30)
        view.addSubview(smallText)
        
        // Create a large text view (24pt bold with icon)
        let largeText = ComponentFactory.shared.createLargeText("Welcome!")
        largeText.frame = CGRect(x: 20, y: 150, width: 300, height: 50)
        view.addSubview(largeText)
    }
}
```

### Fetch Data (Callback Style)

```swift
ComponentFactory.shared.fetchStringArray { items, error in
    if let error = error {
        print("Error: \(error.localizedDescription)")
        return
    }
    
    if let items = items {
        print("Received items: \(items)")
        self.updateUI(with: items)
    }
}
```

### Fetch Data (Async/Await)

```swift
Task {
    do {
        let items = try await ComponentFactory.shared.fetchStringArray()
        print("Received: \(items)")
        await MainActor.run {
            self.updateUI(with: items)
        }
    } catch {
        print("Error: \(error)")
    }
}
```

### SwiftUI Integration

```swift
import SwiftUI
import RNComponentSDK

struct RNTextView: UIViewRepresentable {
    let text: String
    let isLarge: Bool
    
    func makeUIView(context: Context) -> UIView {
        if isLarge {
            return ComponentFactory.shared.createLargeText(text)
        } else {
            return ComponentFactory.shared.createSmallText(text)
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// Usage
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            RNTextView(text: "Small Text", isLarge: false)
                .frame(height: 30)
            
            RNTextView(text: "Large Header", isLarge: true)
                .frame(height: 50)
        }
    }
}
```

## API Reference

### ComponentFactory.shared

Main singleton providing all SDK functionality.

#### Methods

**`createSmallText(_ text: String) -> UIView`**

Creates a view displaying text in 14pt font.

```swift
let view = ComponentFactory.shared.createSmallText("Hello")
view.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
parentView.addSubview(view)
```

**`createLargeText(_ text: String) -> UIView`**

Creates a view displaying text in 24pt bold with a check icon.

```swift
let view = ComponentFactory.shared.createLargeText("Success!")
view.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
parentView.addSubview(view)
```

**`fetchStringArray(completion: @escaping ([String]?, Error?) -> Void)`**

Fetches an array of strings asynchronously (callback style).

```swift
ComponentFactory.shared.fetchStringArray { items, error in
    guard let items = items else { return }
    print("Items: \(items)")
}
```

**`fetchStringArray() async throws -> [String]`**

Fetches an array of strings asynchronously (async/await style, iOS 13+).

```swift
let items = try await ComponentFactory.shared.fetchStringArray()
print("Items: \(items)")
```

## Troubleshooting

### "No such module 'RNComponentSDK'"

**Solution**: Ensure you opened `.xcworkspace`, not `.xcodeproj`

```bash
open YourApp.xcworkspace
```

### "No such module 'React'"

**Solution**: React Native is not configured. Add to your Podfile:

```ruby
use_react_native!(
  :path => './node_modules/react-native',
  :hermes_enabled => true
)
```

### Components Not Rendering

**Solution**: Set explicit frame or constraints:

```swift
let view = ComponentFactory.shared.createSmallText("Hello")
view.frame = CGRect(x: 0, y: 0, width: 200, height: 30)  // Required!
parentView.addSubview(view)
```

### "Bundle not found" Error

**Solution**: Clean and reinstall:

```bash
cd ios
rm -rf Pods Podfile.lock
pod install
```

## Version Compatibility

| RNComponentSDK | React Native | iOS    | Xcode |
|----------------|--------------|--------|-------|
| 1.0.0          | 0.81.x       | 15.1+  | 14.0+ |

## Development Setup

If you want to develop/modify the SDK itself:

### 1. Install React Native

The SDK needs React Native for development:

```bash
cd /path/to/RNComponentSDK
npm install
```

This will install React Native 0.81.4 into the local `node_modules/` folder.

### 2. Install CocoaPods Dependencies

```bash
pod install
```

### 3. Open in Xcode

```bash
open RNComponentSDK.xcworkspace
```

**Note**: The `Podfile` and `package.json` in this repo are for SDK development only. Consumers of your SDK don't need these files - they only need the `.podspec`.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Support

For issues or questions, please open an issue on [GitHub](https://github.com/maxim-drobonoh/RNComponentSDK/issues).

---

**Built with React Native + Swift**
