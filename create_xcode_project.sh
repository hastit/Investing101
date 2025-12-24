#!/bin/bash

# Script to create InvestmentApp in Xcode
# This script creates a minimal project structure

echo "📱 Investment Learning App - Quick Setup"
echo ""
echo "This script will guide you to create the project in Xcode."
echo ""
echo "Step 1: Open Xcode"
echo "Step 2: Create a new Xcode project"
echo "Step 3: Configure as follows:"
echo ""
echo "   Product Name: InvestmentApp"
echo "   Interface: SwiftUI"
echo "   Language: Swift"
echo ""
echo "Step 4: Save in current directory (/Users/hasti/Desktop/cursorapp/)"
echo ""
echo "Step 5: After project is created, run:"
echo "   ./import_files.sh"
echo ""
echo "All your Swift files are ready and waiting in:"
echo "  - InvestmentAppApp.swift (main entry)"
echo "  - ContentView.swift (tab bar)"
echo "  - Views/ folder (4 view files)"
echo "  - Models/ folder (Stock.swift)"
echo "  - Managers/ folder (PortfolioManager.swift)"
echo ""
echo "Press any key to continue and open Xcode..."
read -n 1 -s
open -a Xcode

