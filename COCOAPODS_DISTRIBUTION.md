# CocoaPods Distribution Guide for RNComponentSDK

Complete guide to distribute RNComponentSDK via CocoaPods.

## 📋 Prerequisites Checklist

- ✅ SDK source code ready (`RNComponentSDK/`)
- ✅ Podspec created (`RNComponentSDK.podspec`)
- ✅ `.gitignore` configured
- ✅ Documentation complete
- ✅ LICENSE file (MIT)

## 🚀 Distribution Steps

### Step 1: Verify Podspec

```bash
cd RNComponentSDK
pod spec lint --allow-warnings
```

**Expected output:**
```
-> RNComponentSDK (1.0.0)
    - WARN  | summary: The summary is not meaningful.
    
RNComponentSDK passed validation.
```

**Note:** Warnings are OK for now. Errors must be fixed.

---

### Step 2: Initialize Git Repository (if not already)

```bash
cd /Users/mac/Development/todolistsdk/RNComponentSDK

# Initialize git (if needed)
git init

# Add remote (replace with your repo URL)
git remote add origin https://github.com/yourorg/RNComponentSDK.git
```

---

### Step 3: Add Files to Git

**Files to COMMIT (✅):**
```bash
git add RNComponentSDK/              # Source code
git add RNComponentSDK.podspec       # Pod specification
git add LICENSE                      # MIT license
git add README.md                    # Main docs
git add QUICK_START.md               # Quick start guide
git add INTEGRATION_GUIDE.md         # Detailed guide
git add DISTRIBUTION_GUIDE.md        # Distribution info
git add XCODE_SETUP.md              # Xcode setup
git add .gitignore                   # Git ignore rules
git add package.json                 # Node package
git add react-native.config.js       # RN config
```

**Files to IGNORE (❌):**
```bash
# Already in .gitignore - DO NOT COMMIT:
Pods/                    # CocoaPods dependencies
Podfile.lock             # Lock file
build/                   # Build artifacts
*.xcworkspace            # Generated workspace
DerivedData/             # Xcode build data
*.log                    # Log files
```

---

### Step 4: Commit and Tag

```bash
# Check what will be committed
git status

# Add files
git add .

# Commit
git commit -m "Initial release of RNComponentSDK v1.0.0

- Swift wrapper for React Native components
- Clean public API: SmallTextComponent, LargeTextComponent
- Async string array fetching
- Comprehensive documentation
- CocoaPods distribution ready"

# Tag the release
git tag 1.0.0

# Push to remote
git push origin main
git push origin 1.0.0
```

---

### Step 5: Test Pod Locally

Before distributing, test that consumers can install it:

#### Create Test App

```bash
cd /Users/mac/Development/todolistsdk

# Create test iOS app
npx create-expo-app TestRNComponentSDK
cd TestRNComponentSDK
npx expo prebuild
```

#### Add to Test App's Podfile

```ruby
# ios/Podfile
require File.join(File.dirname(`node --print "require.resolve('react-native/package.json')"`), "scripts/react_native_pods")

platform :ios, '15.1'
prepare_react_native_project!

target 'TestRNComponentSDK' do
  use_frameworks! :linkage => :static
  
  # React Native
  use_react_native!(
    :path => '../node_modules/react-native',
    :hermes_enabled => true
  )
  
  # Your SDK - test with local path first
  pod 'RNComponentSDK', :path => '../RNComponentSDK'
end

post_install do |installer|
  react_native_post_install(
    installer,
    '../node_modules/react-native',
    :mac_catalyst_enabled => false
  )
end
```

#### Install and Test

```bash
cd ios
export LANG=en_US.UTF-8
pod install

# Open workspace
open TestRNComponentSDK.xcworkspace
```

#### Test in Swift

```swift
// TestRNComponentSDK/App.tsx or create a new Swift file
import RNComponentSDK

// In your view controller
let text = ComponentFactory.shared.createLargeText("It Works!")
text.frame = CGRect(x: 20, y: 100, width: 300, height: 50)
view.addSubview(text)
```

**Build and run** - if it works, you're ready to distribute! ✅

---

### Step 6: Distribution Options

#### Option A: Public GitHub + CocoaPods Trunk

**Best for**: Open source projects

1. **Push to GitHub:**
   ```bash
   # Create repo on GitHub first, then:
   git remote set-url origin https://github.com/yourorg/RNComponentSDK.git
   git push -u origin main
   git push origin 1.0.0
   ```

2. **Register with CocoaPods Trunk:**
   ```bash
   # One-time setup
   pod trunk register email@example.com 'Your Name'
   
   # Check your email for confirmation
   ```

3. **Publish to CocoaPods:**
   ```bash
   cd RNComponentSDK
   pod trunk push RNComponentSDK.podspec --allow-warnings
   ```

4. **Consumers install via:**
   ```ruby
   pod 'RNComponentSDK', '~> 1.0.0'
   ```

#### Option B: Private Git Repository

**Best for**: Internal/private projects

1. **Push to private Git:**
   ```bash
   git remote add origin https://github.com/yourorg/RNComponentSDK.git
   git push -u origin main
   git push origin 1.0.0
   ```

2. **Consumers install via Git URL:**
   ```ruby
   pod 'RNComponentSDK', :git => 'https://github.com/yourorg/RNComponentSDK.git', :tag => '1.0.0'
   ```

#### Option C: Private CocoaPods Spec Repo

**Best for**: Multiple internal pods

1. **Create private spec repo:**
   ```bash
   pod repo add YourCompanySpecs https://github.com/yourorg/Specs.git
   ```

2. **Push podspec to private repo:**
   ```bash
   pod repo push YourCompanySpecs RNComponentSDK.podspec --allow-warnings
   ```

3. **Consumers add source to Podfile:**
   ```ruby
   source 'https://github.com/yourorg/Specs.git'
   source 'https://cdn.cocoapods.org/'  # For React Native
   
   pod 'RNComponentSDK', '~> 1.0.0'
   ```

#### Option D: Local Development

**Best for**: Testing, development

```ruby
# Consumer's Podfile
pod 'RNComponentSDK', :path => '../RNComponentSDK'
```

---

## 📝 Updating the SDK

### Release New Version

1. **Make changes** to source code

2. **Rebuild JS bundle** (if React Native components changed):
   ```bash
   cd ../RNLib
   npm run bundle:ios
   cp ios/main.jsbundle ../RNComponentSDK/RNComponentSDK/Resources/
   ```

3. **Update version** in `RNComponentSDK.podspec`:
   ```ruby
   s.version = '1.1.0'
   ```

4. **Commit and tag**:
   ```bash
   git add .
   git commit -m "Release v1.1.0 - Add new features"
   git tag 1.1.0
   git push origin main
   git push origin 1.1.0
   ```

5. **Publish** (if using CocoaPods Trunk):
   ```bash
   pod trunk push RNComponentSDK.podspec --allow-warnings
   ```

### Consumers Update

```bash
pod update RNComponentSDK
```

---

## 🔍 Verification Checklist

Before distributing, verify:

- ✅ **Podspec validates:** `pod spec lint --allow-warnings`
- ✅ **Git repo is clean:** `git status`
- ✅ **Version is tagged:** `git tag`
- ✅ **Source files committed:** Check `RNComponentSDK/` directory
- ✅ **Resources included:** `main.jsbundle`, `MaterialIcons.ttf`
- ✅ **Documentation complete:** README, guides
- ✅ **LICENSE file present:** MIT license
- ✅ **.gitignore correct:** `Pods/`, `build/` ignored
- ✅ **Test app works:** Local pod installation successful

---

## 📦 What Gets Distributed

When consumers run `pod install`, they get:

**Source Files:**
- `RNComponentSDK.h`
- `RNBridgeManager.swift`
- `ComponentFactory.swift`
- `Info.plist`

**Resources:**
- `main.jsbundle` (1.4 MB)
- `MaterialIcons.ttf` (348 KB)

**Dependencies (automatically resolved):**
- React-Core
- React-hermes
- hermes-engine
- All other React Native pods

---

## 🎯 Consumer Experience

### Installation

```ruby
# Add one line to Podfile
pod 'RNComponentSDK', '~> 1.0.0'
```

```bash
# Run pod install
pod install
```

### Usage

```swift
import RNComponentSDK

// Works immediately!
let view = ComponentFactory.shared.createLargeText("Hello!")
```

---

## ⚠️ Common Issues

### Issue: "No podspec found"

**Solution:** Ensure `RNComponentSDK.podspec` is in the root directory.

### Issue: "Unable to find React-Core"

**Solution:** Consumer must have React Native configured:
```ruby
use_react_native!(:path => './node_modules/react-native')
```

### Issue: "Bundle not found"

**Solution:** Ensure `main.jsbundle` is in `RNComponentSDK/Resources/` and committed to Git.

### Issue: "Version mismatch"

**Solution:** Match React Native versions between SDK and consumer app.

---

## 📊 Distribution Comparison

| Method | Public | Private | Versioning | Easy Updates |
|--------|--------|---------|------------|--------------|
| **CocoaPods Trunk** | ✅ | ❌ | ✅ | ✅ |
| **Git URL** | ✅ | ✅ | ✅ | ⭐⭐ |
| **Private Spec Repo** | ❌ | ✅ | ✅ | ✅ |
| **Local Path** | ❌ | ✅ | ❌ | ❌ |

---

## 🚀 Recommended: Git URL Distribution

**Why:**
- ✅ Works for both public and private repos
- ✅ No CocoaPods Trunk account needed
- ✅ Easy to test before publishing
- ✅ Full version control with tags
- ✅ Simple for consumers

**Podspec Configuration:**

Your `RNComponentSDK.podspec` is already configured:
```ruby
s.source = { :git => 'https://github.com/yourorg/RNComponentSDK.git', :tag => s.version.to_s }
```

**Consumer Usage:**
```ruby
pod 'RNComponentSDK', :git => 'https://github.com/yourorg/RNComponentSDK.git', :tag => '1.0.0'
```

---

## ✅ Quick Start Distribution

**Ready to distribute NOW:**

```bash
# 1. Ensure you're in RNComponentSDK directory
cd /Users/mac/Development/todolistsdk/RNComponentSDK

# 2. Verify podspec
pod spec lint --allow-warnings

# 3. Initialize git (if needed)
git init

# 4. Add files
git add .

# 5. Commit
git commit -m "Release v1.0.0"

# 6. Add remote (update URL!)
git remote add origin https://github.com/yourorg/RNComponentSDK.git

# 7. Tag version
git tag 1.0.0

# 8. Push
git push -u origin main
git push origin 1.0.0
```

**Done!** Share the Git URL with consumers.

---

## 📚 Resources

- **Your Podspec:** `RNComponentSDK.podspec`
- **Consumer Guide:** `QUICK_START.md`
- **API Reference:** `README.md`
- **Examples:** `INTEGRATION_GUIDE.md`

---

## 🎉 Success!

Your SDK is now ready for CocoaPods distribution!

**Next steps:**
1. Update Git URL in podspec
2. Push to GitHub/GitLab
3. Share with consumers
4. Monitor for feedback

**Consumers can install with just 3 lines:**
```ruby
pod 'RNComponentSDK', :git => 'YOUR_GIT_URL', :tag => '1.0.0'
```

🚀 **Happy distributing!**

