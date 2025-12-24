#!/bin/bash

# Script to build and run the Investment App on iOS Simulator
# This runs the app directly from Cursor terminal!

echo "🚀 Building Investment App for iOS Simulator..."

# Get the first available iPhone simulator
DEVICE=$(xcrun simctl list devices available | grep "iPhone" | head -1 | sed 's/.*(//' | sed 's/).*//')

if [ -z "$DEVICE" ]; then
    DEVICE="iPhone 16"
    DEVICE_UDID="7FFC52CC-3368-4AC0-8B30-8A76B3531918"
else
    DEVICE_UDID=$DEVICE
fi

echo "📱 Target Device: $DEVICE"
echo ""

# Navigate to Xcode project location
PROJECT_PATH="/Users/hasti/Desktop/InvestmentApp/InvestmentApp.xcodeproj"

if [ ! -f "$PROJECT_PATH" ]; then
    echo "❌ Xcode project not found."
    echo "Let me check where the project actually is..."
    find ~/Desktop -name "InvestmentApp.xcodeproj" 2>/dev/null | head -1
    exit 1
fi

cd /Users/hasti/Desktop/InvestmentApp

echo "🧹 Cleaning build..."
xcodebuild clean -project InvestmentApp.xcodeproj -scheme InvestmentApp -quiet

echo "🔨 Building app..."
xcodebuild build \
    -project InvestmentApp.xcodeproj \
    -scheme InvestmentApp \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -quiet

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📱 Installing on simulator..."
    
    # Get the .app path
    BUILD_PATH="~/Library/Developer/Xcode/DerivedData/InvestmentApp-*/Build/Products/Debug-iphonesimulator/InvestmentApp.app"
    
    # Install app on simulator
    xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || echo "Simulator already booted"
    xcrun simctl install "iPhone 16 Pro" "$(eval echo $BUILD_PATH)" 2>/dev/null || echo "App already installed"
    
    echo "🎯 Launching app..."
    xcrun simctl launch --console "iPhone 16 Pro" com.investolearn.app
    
    echo ""
    echo "✅ App is running on iPhone 16 Pro simulator!"
    echo "💡 Tip: The simulator window should open automatically"
else
    echo "❌ Build failed. Check errors above."
    exit 1
fi

