#!/bin/bash

# Quick build script for the Investment App

echo "🔨 Building Investment App..."

PROJECT_DIR="/Users/hasti/Desktop/InvestmentApp/InvestmentApp"

if [ -d "$PROJECT_DIR" ]; then
    cd "$PROJECT_DIR"
    echo "📁 Working in: $PROJECT_DIR"
else
    echo "❌ Xcode project directory not found at: $PROJECT_DIR"
    echo "Searching for project..."
    find ~/Desktop -name "InvestmentApp.xcodeproj" -type d
    exit 1
fi

xcodebuild build \
    -project InvestmentApp.xcodeproj \
    -scheme InvestmentApp \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -quiet

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Run './open_simulator.sh' to launch the app"
else
    echo "❌ Build failed"
    exit 1
fi

