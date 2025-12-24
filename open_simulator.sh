#!/bin/bash

# Open the iOS Simulator with the app

echo "📱 Opening iOS Simulator..."

# Boot the simulator
xcrun simctl boot "iPhone 16 Pro" 2>/dev/null

# Open Simulator app
open -a Simulator

echo "✅ Simulator is opening..."
echo "💡 Once it's ready, you can install the app or run './run_app.sh' to launch automatically"

