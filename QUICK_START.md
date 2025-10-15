# RNComponentSDK - Quick Start

## 🚀 5-Minute Integration

The framework uses **CocoaPods source distribution** instead of XCFramework (see [DISTRIBUTION_GUIDE.md](DISTRIBUTION_GUIDE.md) for why).

### Prerequisites

- Xcode 14+
- iOS 15.1+
- React Native app (Expo or RN CLI)
- CocoaPods

### Step 1: Add to Podfile

```ruby
# In your app's Podfile

# Ensure React Native is configured
require_relative '../node_modules/react-native/scripts/react_native_pods'

platform :ios, '15.1'
prepare_react_native_project!

target 'YourApp' do
  use_frameworks! :linkage => :static
  
  # React Native (required)
  use_react_native!(
    :path => './node_modules/react-native',
    :hermes_enabled => true
  )
  
  # Add the SDK (local path for testing)
  pod 'RNComponentSDK', :path => '../RNComponentSDK'
  
  # Or from Git:
  # pod 'RNComponentSDK', :git => 'https://github.com/yourorg/RNComponentSDK.git'
end
```

### Step 2: Install

```bash
cd YourApp/ios
pod install
```

### Step 3: Use in Swift

```swift
import UIKit
import RNComponentSDK

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create small text (14pt)
        let smallText = ComponentFactory.shared.createSmallText("Hello, iOS!")
        smallText.frame = CGRect(x: 20, y: 100, width: 300, height: 30)
        view.addSubview(smallText)
        
        // Create large text with icon (24pt bold + check icon)
        let largeText = ComponentFactory.shared.createLargeText("Welcome!")
        largeText.frame = CGRect(x: 20, y: 150, width: 300, height: 50)
        view.addSubview(largeText)
        
        // Fetch data async
        Task {
            do {
                let items = try await ComponentFactory.shared.fetchStringArray()
                print("Received: \\(items)")
                // ["Data 1", "Data 2", "Data 3"]
            } catch {
                print("Error: \\(error)")
            }
        }
    }
}
```

## 🎯 That's It!

Three steps and you're done:
1. ✅ Add pod dependency
2. ✅ Run `pod install`
3. ✅ Import and use

## 📚 More Examples

### With Auto Layout

```swift
let textView = ComponentFactory.shared.createLargeText("Success!")
textView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(textView)

NSLayoutConstraint.activate([
    textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
    textView.heightAnchor.constraint(equalToConstant: 50)
])
```

### In SwiftUI

```swift
import SwiftUI
import RNComponentSDK

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            ComponentViewWrapper(text: "Hello", isLarge: false)
                .frame(height: 30)
            
            ComponentViewWrapper(text: "World!", isLarge: true)
                .frame(height: 50)
        }
        .padding()
    }
}

struct ComponentViewWrapper: UIViewRepresentable {
    let text: String
    let isLarge: Bool
    
    func makeUIView(context: Context) -> UIView {
        isLarge 
            ? ComponentFactory.shared.createLargeText(text)
            : ComponentFactory.shared.createSmallText(text)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
```

### Callback Style

```swift
ComponentFactory.shared.fetchStringArray { items, error in
    if let error = error {
        print("Error: \\(error)")
        return
    }
    
    guard let items = items else { return }
    print("Got \\(items.count) items")
}
```

## 🔧 Troubleshooting

### Module not found
Ensure your Podfile includes `use_react_native!(...)`.

### Components not rendering
Check that React Native is properly initialized in your app.

### Build errors
Clean and rebuild: **Product → Clean Build Folder** (⌘+Shift+K)

## 📖 Full Documentation

- [README.md](README.md) - Complete API reference
- [INTEGRATION_GUIDE.md](INTEGRATION_GUIDE.md) - Detailed examples
- [DISTRIBUTION_GUIDE.md](DISTRIBUTION_GUIDE.md) - Distribution options

## 💡 Pro Tip

The SDK is distributed as **source code**, not a binary framework. This means:
- ✅ Full debugging support
- ✅ See implementation in Xcode
- ✅ Easy to modify for your needs
- ✅ No black box

---

**Questions?** Check the full documentation or open an issue!

