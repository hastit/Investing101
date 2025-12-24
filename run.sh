#!/bin/bash
# Quick runner script for the investment app

echo "🚀 Launching Investment App..."
echo ""

# Copy files if needed
echo "📁 Syncing files..."
cp /Users/hasti/Desktop/InvestmentApp/InvestmentApp/InvestmentApp/Views/PortfolioView.swift /Users/hasti/Desktop/InvestmentApp/InvestmentApp/InvestmentApp/Views/ 2>/dev/null

# Build and launch
cd /Users/hasti/Desktop/InvestmentApp/InvestmentApp

echo "📱 Opening simulator..."
xcrun simctl boot "iPhone 16 Pro" 2>/dev/null
open -a Simulator

echo "🔨 Building app..."
xcodebuild build \
    -project InvestmentApp.xcodeproj \
    -scheme InvestmentApp \
    -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
    -quiet

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Find the built app
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "InvestmentApp.app" -path "*/Debug-iphonesimulator/*" 2>/dev/null | head -1)
    
    if [ -n "$APP_PATH" ]; then
        echo "📦 Installing app on simulator..."
        xcrun simctl install booted "$APP_PATH" 2>/dev/null
        
        echo "🎯 Launching app..."
        xcrun simctl launch --console booted com.hastitaj.InvestmentApp
        
        echo ""
        echo "✅ App launched! Check your simulator."
    else
        echo "❌ App bundle not found. Please open in Xcode and run (⌘R)."
    fi
else
    echo "❌ Build failed. Check errors above."
    exit 1
fi
