# Workflow: Run iOS App from Cursor

You can now edit and run your iOS app entirely from Cursor! No more copying files back and forth.

## Quick Commands

### 🏗️ Build the app
```bash
./build_only.sh
```

### 🚀 Build and Launch
```bash
./launch_app.sh
```

### 📱 Just open simulator
```bash
./open_simulator.sh
```

## How It Works

1. **Edit files in Cursor** - All your Swift files are in `Views/`, `Models/`, `Managers/`
2. **Copy to Xcode project** - The scripts automatically sync your changes
3. **Build & run** - One command launches everything

## Example Workflow

```bash
# 1. Edit a file (e.g., Views/PortfolioView.swift)
# Make your changes...

# 2. Save the file in Cursor

# 3. Run the app
./launch_app.sh
```

The app will build and launch on the iPhone 16 Pro simulator automatically!

## File Locations

- **Source files (edit these)**: `cursorapp/Views/`, `cursorapp/Models/`, etc.
- **Xcode project**: `/Users/hasti/Desktop/InvestmentApp/InvestmentApp/`
- **Build output**: Automatically handled by the scripts

## Troubleshooting

**Build fails?**
```bash
# Clean and rebuild
cd /Users/hasti/Desktop/InvestmentApp/InvestmentApp
xcodebuild clean -project InvestmentApp.xcodeproj
./build_only.sh
```

**Simulator not opening?**
```bash
# Open simulator manually
open -a Simulator
```

**Files not syncing?**
The files are automatically copied when you run `./build_only.sh` or `./launch_app.sh`

