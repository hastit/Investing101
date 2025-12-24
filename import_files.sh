#!/bin/bash

# After creating the project in Xcode, run this script
# to copy the instruction file for adding files

echo "📁 Import Instructions"
echo ""
echo "Follow these steps to add files to your Xcode project:"
echo ""
echo "1. In Xcode, delete the auto-generated files:"
echo "   - Right-click ContentView.swift > Delete > Move to Trash"
echo "   - Right-click InvestmentAppApp.swift > Delete > Move to Trash"
echo ""
echo "2. Create folders:"
echo "   - Right-click 'InvestmentApp' > New Group > Name it 'Views'"
echo "   - Right-click 'InvestmentApp' > New Group > Name it 'Models'"
echo "   - Right-click 'InvestmentApp' > New Group > Name it 'Managers'"
echo ""
echo "3. Drag files from Finder into Xcode:"
echo "   - InvestmentAppApp.swift → InvestmentApp root"
echo "   - ContentView.swift → InvestmentApp root"
echo "   - Info.plist → InvestmentApp root"
echo "   - PortfolioView.swift → Views folder"
echo "   - LearnView.swift → Views folder"
echo "   - ArticlesView.swift → Views folder"
echo "   - ProfileView.swift → Views folder"
echo "   - Stock.swift → Models folder"
echo "   - PortfolioManager.swift → Managers folder"
echo ""
echo "4. Build and Run (Cmd+R)"
echo ""
echo "Files are located in: $(pwd)"

