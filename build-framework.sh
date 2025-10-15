#!/bin/bash

#
# build-framework.sh
# Builds RNComponentSDK.xcframework for iOS Simulator and Device
#

set -e  # Exit on error

FRAMEWORK_NAME="RNComponentSDK"
BUILD_DIR="./build"
DERIVED_DATA_PATH="$BUILD_DIR/DerivedData"
XCFRAMEWORK_PATH="$BUILD_DIR/${FRAMEWORK_NAME}.xcframework"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Building ${FRAMEWORK_NAME}.xcframework${NC}"
echo ""

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Install CocoaPods if needed
if [ ! -d "Pods" ]; then
    echo -e "${YELLOW}📦 Installing CocoaPods dependencies...${NC}"
    export LANG=en_US.UTF-8
    pod install
fi

# Build for iOS Simulator (arm64 + x86_64)
echo -e "${YELLOW}🏗️  Building for iOS Simulator (arm64 + x86_64)...${NC}"
xcodebuild archive \
    -workspace ${FRAMEWORK_NAME}.xcworkspace \
    -scheme ${FRAMEWORK_NAME} \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$BUILD_DIR/simulator.xcarchive" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ONLY_ACTIVE_ARCH=NO

# Build for iOS Device (arm64)
echo -e "${YELLOW}🏗️  Building for iOS Device (arm64)...${NC}"
xcodebuild archive \
    -workspace ${FRAMEWORK_NAME}.xcworkspace \
    -scheme ${FRAMEWORK_NAME} \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "$BUILD_DIR/iphoneos.xcarchive" \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    ONLY_ACTIVE_ARCH=NO

# Create XCFramework
echo -e "${YELLOW}📦 Creating XCFramework...${NC}"
xcodebuild -create-xcframework \
    -framework "$BUILD_DIR/simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -framework "$BUILD_DIR/iphoneos.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
    -output "$XCFRAMEWORK_PATH"

# Print success message
echo ""
echo -e "${GREEN}✅ Successfully built ${FRAMEWORK_NAME}.xcframework!${NC}"
echo -e "${GREEN}📍 Location: $XCFRAMEWORK_PATH${NC}"
echo ""

# Get framework size
FRAMEWORK_SIZE=$(du -sh "$XCFRAMEWORK_PATH" | cut -f1)
echo -e "${GREEN}📊 Framework size: $FRAMEWORK_SIZE${NC}"

# List architectures
echo ""
echo -e "${YELLOW}🏛️  Architectures:${NC}"
echo "  iOS Simulator: arm64, x86_64"
echo "  iOS Device: arm64"
echo ""

# Print usage instructions
echo -e "${YELLOW}📚 Usage:${NC}"
echo "  1. Drag ${FRAMEWORK_NAME}.xcframework into your Xcode project"
echo "  2. In 'Frameworks, Libraries, and Embedded Content', set to 'Embed & Sign'"
echo "  3. Import in Swift: import ${FRAMEWORK_NAME}"
echo ""

echo -e "${GREEN}🎉 Build complete!${NC}"

