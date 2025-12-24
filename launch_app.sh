#!/bin/bash

# Launch the Investment App on iOS Simulator

echo "🚀 Launching Investment App..."

PROJECT_DIR="/Users/hasti/Desktop/InvestmentApp/InvestmentApp"
cd "$PROJECT_DIR"

# Boot the simulator if not already running
echo "📱 Starting simulator..."
xcrun simctl boot "iPhone 16 Pro" 2>/dev/null || echo "Simulator already running"
open -a Simulator
sleep 3

# Get the .app path
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/InvestmentApp-*/Build/Products/Debug-iphonesimulator/InvestmentApp.app -maxdepth 0 2>/dev/null | head -1)

if [ -z "$APP_PATH" ]; then
    echo "❌ App not found. Building first..."
    ./build_only.sh
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData/InvestmentApp-*/Build/Products/Debug-iphonesimulator/InvestmentApp.app -maxdepth 0 2>/dev/null | head -1)
fi

if [ -n "$APP_PATH" ]; then
    echo "📱 Installing and launching app..."
    xcrun simctl install "iPhone 16 Pro" "$APP_PATH"
    xcrun simctl launch --console "iPhone 16 Pro" com.investolearn.app
    echo "✅ App launched!"
else
    echo "❌ Could not find app bundle"
    exit 1
fi

