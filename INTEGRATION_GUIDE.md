# RNComponentSDK Integration Guide

Complete guide for integrating RNComponentSDK into your iOS project.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Basic Usage](#basic-usage)
4. [Advanced Usage](#advanced-usage)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

- **Xcode**: 14.0 or later
- **iOS Deployment Target**: 13.0 or later
- **Swift**: 5.0 or later
- **Development Tools**: CocoaPods (for building from source)

## Installation

### Option 1: Using Pre-built XCFramework

1. **Build the framework** (or obtain pre-built):
   ```bash
   cd RNComponentSDK
   ./build-framework.sh
   ```

2. **Add to Xcode Project**:
   - Drag `build/RNComponentSDK.xcframework` into your project
   - In project navigator, select your target
   - Go to "General" → "Frameworks, Libraries, and Embedded Content"
   - Ensure RNComponentSDK is set to **"Embed & Sign"**

3. **Verify Installation**:
   - Build your project (`⌘+B`)
   - Should compile without errors

### Option 2: Building from Source

If you need to modify or rebuild the framework:

```bash
# 1. Clone repository
git clone <repository-url>
cd todolistsdk

# 2. Build JavaScript bundle
cd RNLib
npm install
npm run bundle:ios

# 3. Setup framework
cd ../RNComponentSDK
cp ../RNLib/ios/main.jsbundle RNComponentSDK/Resources/
pod install

# 4. Build framework
./build-framework.sh
```

## Basic Usage

### 1. Import the Framework

```swift
import UIKit
import RNComponentSDK
```

### 2. Create Components

#### Simple Text Component

```swift
class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = ComponentFactory.shared.createSmallText("Hello, iOS!")
        textView.frame = CGRect(x: 20, y: 100, width: 300, height: 30)
        textView.backgroundColor = .white
        view.addSubview(textView)
    }
}
```

#### Large Text with Icon

```swift
let headerView = ComponentFactory.shared.createLargeText("Success!")
headerView.frame = CGRect(x: 20, y: 150, width: 300, height: 50)
view.addSubview(headerView)
```

### 3. Fetch Data

#### Using Callbacks

```swift
ComponentFactory.shared.fetchStringArray { items, error in
    if let error = error {
        print("Error fetching data: \\(error.localizedDescription)")
        return
    }
    
    if let items = items {
        print("Received \\(items.count) items")
        self.updateUI(with: items)
    }
}
```

#### Using Async/Await (iOS 13+)

```swift
Task {
    do {
        let items = try await ComponentFactory.shared.fetchStringArray()
        await MainActor.run {
            self.updateUI(with: items)
        }
    } catch {
        print("Error: \\(error)")
    }
}
```

## Advanced Usage

### Auto Layout Integration

```swift
let textView = ComponentFactory.shared.createSmallText("Dynamic Text")
textView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(textView)

NSLayoutConstraint.activate([
    textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
    textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    textView.heightAnchor.constraint(equalToConstant: 50)
])
```

### UITableView Integration

```swift
class MyTableViewController: UITableViewController {
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func loadItems() {
        ComponentFactory.shared.fetchStringArray { [weak self] items, error in
            guard let items = items else { return }
            self?.items = items
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        
        // Remove previous subviews
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Add component
        let textView = ComponentFactory.shared.createSmallText(items[indexPath.row])
        textView.frame = cell.contentView.bounds
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cell.contentView.addSubview(textView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
```

### SwiftUI Integration

```swift
import SwiftUI
import RNComponentSDK

struct ComponentView: UIViewRepresentable {
    let text: String
    let isLarge: Bool
    
    func makeUIView(context: Context) -> UIView {
        if isLarge {
            return ComponentFactory.shared.createLargeText(text)
        } else {
            return ComponentFactory.shared.createSmallText(text)
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Components are immutable - recreate if text changes
    }
}

// Usage in SwiftUI
struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            ComponentView(text: "Small Text", isLarge: false)
                .frame(height: 30)
            
            ComponentView(text: "Large Header", isLarge: true)
                .frame(height: 50)
        }
        .padding()
    }
}
```

### Custom Container View

```swift
class ComponentContainerView: UIView {
    private var componentView: UIView?
    
    var text: String = "" {
        didSet {
            updateComponent()
        }
    }
    
    var isLarge: Bool = false {
        didSet {
            updateComponent()
        }
    }
    
    private func updateComponent() {
        componentView?.removeFromSuperview()
        
        let newView = isLarge 
            ? ComponentFactory.shared.createLargeText(text)
            : ComponentFactory.shared.createSmallText(text)
        
        newView.frame = bounds
        newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(newView)
        componentView = newView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        componentView?.frame = bounds
    }
}
```

## Best Practices

### 1. Component Lifecycle

```swift
class MyViewController: UIViewController {
    private var componentViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createComponents()
    }
    
    private func createComponents() {
        // Create all components
        let view1 = ComponentFactory.shared.createSmallText("Item 1")
        componentViews.append(view1)
        // ... add to hierarchy
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clean up if needed
        componentViews.forEach { $0.removeFromSuperview() }
        componentViews.removeAll()
    }
}
```

### 2. Error Handling

```swift
func loadData() {
    ComponentFactory.shared.fetchStringArray { [weak self] items, error in
        // Always check for errors first
        if let error = error {
            self?.showAlert(message: "Failed to load data: \\(error.localizedDescription)")
            return
        }
        
        // Use guard for cleaner code
        guard let items = items, !items.isEmpty else {
            self?.showAlert(message: "No data available")
            return
        }
        
        // Process data
        self?.updateUI(with: items)
    }
}

private func showAlert(message: String) {
    let alert = UIAlertController(
        title: "Error",
        message: message,
        preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
}
```

### 3. Performance Optimization

```swift
// ❌ Bad: Creating new components on every cell dequeue
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    let view = ComponentFactory.shared.createSmallText(items[indexPath.row])
    cell.contentView.addSubview(view)  // Memory leak!
    return cell
}

// ✅ Good: Reuse cells properly
class CustomCell: UITableViewCell {
    var componentView: UIView?
    
    func configure(with text: String) {
        componentView?.removeFromSuperview()
        let view = ComponentFactory.shared.createSmallText(text)
        view.frame = contentView.bounds
        contentView.addSubview(view)
        componentView = view
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        componentView?.removeFromSuperview()
        componentView = nil
    }
}
```

### 4. Thread Safety

```swift
// Always use components on the main thread
func loadAndDisplay() {
    ComponentFactory.shared.fetchStringArray { items, error in
        // This callback is already on main thread, but be explicit
        DispatchQueue.main.async {
            guard let items = items else { return }
            
            // Create and add components on main thread
            items.forEach { text in
                let view = ComponentFactory.shared.createSmallText(text)
                self.stackView.addArrangedSubview(view)
            }
        }
    }
}
```

## Troubleshooting

### Issue: Components not rendering

**Solution**: Ensure bridge is initialized before creating components:

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
    // Check bridge status
    if !RNBridgeManager.shared.initializeBridge() {
        print("ERROR: Failed to initialize bridge")
        return
    }
    
    // Now safe to create components
    createComponents()
}
```

### Issue: Components have wrong size

**Solution**: Set explicit frame or constraints:

```swift
// Option 1: Explicit frame
let view = ComponentFactory.shared.createSmallText("Text")
view.frame = CGRect(x: 0, y: 0, width: 300, height: 50)

// Option 2: Auto Layout
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.heightAnchor.constraint(equalToConstant: 50),
    view.widthAnchor.constraint(equalToConstant: 300)
])
```

### Issue: Icons not displaying

**Solution**: Verify font is in framework resources:

```bash
# Check if font exists
unzip -l build/RNComponentSDK.xcframework/ios-arm64/RNComponentSDK.framework/RNComponentSDK | grep MaterialIcons
```

### Issue: Memory leaks

**Solution**: Always remove views and use weak self:

```swift
ComponentFactory.shared.fetchStringArray { [weak self] items, error in
    guard let self = self else { return }
    // Use self safely
}
```

## Next Steps

- Check out the [API Reference](README.md#api-reference)
- Explore [example projects](../examples/)
- Join our [community discussions](https://github.com/...)

---

**Need help?** Open an issue on GitHub or contact support.

