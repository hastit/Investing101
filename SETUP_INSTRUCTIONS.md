# Investment Learning App - Setup Instructions

## Quick Setup (5 minutes)

### Option 1: Create New Project in Xcode (Recommended)

1. **Open Xcode**
   - Launch Xcode from Applications
   
2. **Create New Project**
   - Choose "Create a new Xcode project"
   - Select "iOS" tab
   - Choose "App" template
   - Click "Next"

3. **Configure Project**
   - Product Name: `InvestmentApp`
   - Team: (your team or personal)
   - Organization Identifier: `com.yourname`
   - Bundle Identifier: `com.yourname.InvestmentApp`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None (default)
   - Click "Next"

4. **Choose Location**
   - Save to: `/Users/hasti/Desktop/cursorapp/`
   - Click "Create"

5. **Add Files to Project**
   - In Xcode, right-click on the `InvestmentApp` folder in the Project Navigator
   - Select "Delete" and choose "Move to Trash" for `ContentView.swift` and `InvestmentAppApp.swift`
   
6. **Drag and Drop Files**
   - Drag these files from Finder into the Xcode project:
     - `InvestmentAppApp.swift`
     - `ContentView.swift`
     - `Info.plist`
   - Create folders:
     - Right-click `InvestmentApp` > New Group > Name it "Views"
     - Right-click `InvestmentApp` > New Group > Name it "Models"
     - Right-click `InvestmentApp` > New Group > Name it "Managers"
   
7. **Add Files to Groups**
   - Drag into `Views` folder:
     - `PortfolioView.swift`
     - `LearnView.swift`
     - `ArticlesView.swift`
     - `ProfileView.swift`
   - Drag into `Models` folder:
     - `Stock.swift`
   - Drag into `Managers` folder:
     - `PortfolioManager.swift`

8. **Update Info.plist**
   - In the Target settings, set the Info.plist File path to `Info.plist`
   
9. **Build and Run**
   - Press `Cmd + R` or click the Play button
   - The app should build and launch in the iOS Simulator

## Alternative: Use Existing Project File

If you already have a project created, you can import the broken project and Xcode will try to repair it:

```bash
# Open in Xcode
open InvestmentApp.xcodeproj
```

If that doesn't work, create a new project as described above.

## Project Structure

```
InvestmentApp/
├── InvestmentAppApp.swift          # Main app entry
├── ContentView.swift               # Tab view
├── Info.plist                      # App configuration
├── Views/
│   ├── PortfolioView.swift        # Trading interface
│   ├── LearnView.swift            # Learning path
│   ├── ArticlesView.swift         # Article reader
│   └── ProfileView.swift          # User profile
├── Models/
│   └── Stock.swift                # Data models
└── Managers/
    └── PortfolioManager.swift     # State management
```

## Verification

After setting up, you should see:
- ✅ 4 tabs at the bottom (Portfolio, Learn, Articles, Profile)
- ✅ 5 stocks available to trade: Gold, Oil, Bitcoin, Apple, Microsoft
- ✅ Starting balance of $10,000 fake money
- ✅ Learning modules with progress tracking
- ✅ 6 educational articles
- ✅ Portfolio tracking with charts

## Troubleshooting

### Error: "Cannot find type"
- Make sure all files are added to the target: Select file > File Inspector > Target Membership > Check "InvestmentApp"

### Error: "Missing Info.plist"
- In Target > Info, set the Info.plist file path correctly

### Charts not showing
- Make sure iOS 16.0+ is set as deployment target

## Next Steps

1. Run the app in the simulator
2. Try buying some stocks in the Portfolio tab
3. Check your holdings in the Profile tab
4. Complete lessons in the Learn tab
5. Read articles for more insights

