#!/bin/bash

# Prepare RNComponentSDK for CocoaPods Distribution
echo "🚀 Preparing RNComponentSDK for Distribution"
echo ""

cd "$(dirname "$0")"

# Step 1: Check resources
echo "📦 Step 1: Verifying resources..."
if [ ! -f "RNComponentSDK/Resources/main.jsbundle" ]; then
    echo "❌ ERROR: main.jsbundle not found!"
    echo "   Run: cd ../RNLib && npm run bundle:ios"
    echo "   Then: cp ios/main.jsbundle ../RNComponentSDK/RNComponentSDK/Resources/"
    exit 1
fi

if [ ! -f "RNComponentSDK/Resources/MaterialIcons.ttf" ]; then
    echo "❌ ERROR: MaterialIcons.ttf not found!"
    echo "   Copy from node_modules/@expo/vector-icons/build/vendor/react-native-vector-icons/Fonts/"
    exit 1
fi

BUNDLE_SIZE=$(ls -lh RNComponentSDK/Resources/main.jsbundle | awk '{print $5}')
FONT_SIZE=$(ls -lh RNComponentSDK/Resources/MaterialIcons.ttf | awk '{print $5}')
echo "✅ main.jsbundle: $BUNDLE_SIZE"
echo "✅ MaterialIcons.ttf: $FONT_SIZE"
echo ""

# Step 2: Verify source files
echo "📝 Step 2: Verifying source files..."
FILES=(
    "RNComponentSDK/RNComponentSDK.h"
    "RNComponentSDK/RNBridgeManager.swift"
    "RNComponentSDK/ComponentFactory.swift"
    "RNComponentSDK/Info.plist"
    "RNComponentSDK.podspec"
    "LICENSE"
    "README.md"
)

for file in "${FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        exit 1
    fi
    echo "✅ $file"
done
echo ""

# Step 3: Check git status
echo "🔍 Step 3: Checking Git status..."
if [ ! -d ".git" ]; then
    echo "⚠️  Git not initialized. Run:"
    echo "   git init"
    echo "   git add ."
    echo "   git commit -m 'Initial release v1.0.0'"
else
    echo "✅ Git initialized"
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo "⚠️  You have uncommitted changes:"
        git status --short
        echo ""
    else
        echo "✅ No uncommitted changes"
    fi
fi
echo ""

# Step 4: Check podspec
echo "📋 Step 4: Checking podspec..."
VERSION=$(grep "s.version" RNComponentSDK.podspec | sed 's/.*= //' | tr -d "'\" ")
HOMEPAGE=$(grep "s.homepage" RNComponentSDK.podspec | grep -o 'https://[^'"'"']*')
echo "   Version: $VERSION"
echo "   Homepage: $HOMEPAGE"

if [[ "$HOMEPAGE" == *"yourorg"* ]]; then
    echo "⚠️  Update homepage in RNComponentSDK.podspec with your actual repo URL"
fi
echo ""

# Step 5: Summary
echo "📊 Distribution Summary"
echo "════════════════════════════════════════════════"
echo ""
echo "✅ All source files present"
echo "✅ Resources bundled (${BUNDLE_SIZE} + ${FONT_SIZE})"
echo "✅ Ready for Git distribution"
echo ""
echo "📌 Next Steps:"
echo "   1. Update URLs in RNComponentSDK.podspec"
echo "   2. git add ."
echo "   3. git commit -m 'Release v${VERSION}'"
echo "   4. git remote add origin <YOUR_REPO_URL>"
echo "   5. git tag ${VERSION}"
echo "   6. git push -u origin main"
echo "   7. git push origin ${VERSION}"
echo ""
echo "📚 Consumers install via:"
echo "   pod 'RNComponentSDK', :git => '<YOUR_REPO_URL>', :tag => '${VERSION}'"
echo ""
echo "🎉 SDK is ready for distribution!"
echo ""

