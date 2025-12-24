# Investment Learning App

A comprehensive iOS app for learning about investing with a simulated trading portfolio.

## Features

### 📊 Portfolio Page
- Interactive stock graphs for 5 assets: Gold, Oil, Bitcoin, Apple (AAPL), and Microsoft (MSFT)
- Real-time price tracking with mini charts
- Trade stocks with virtual money ($10,000 starting balance)
- View holdings and profit/loss tracking

### 📚 Learn Page
- Duolingo-style learning path with interactive lessons
- 4 learning modules:
  - Investment Basics
  - Stock Market
  - Cryptocurrency
  - Commodities
- Progress tracking with completion badges

### 📖 Articles Page
- Curated articles about investing strategies and methods
- Categories: Strategy, Education, Basics, Technical Analysis, Cryptocurrency
- Read-time estimates for each article

### 👤 Profile Page
- Portfolio value tracking
- Available cash display
- Holdings overview with individual stock performance
- Portfolio allocation pie chart
- Recent transaction history

## Getting Started

### Requirements
- iOS 16.0+
- Xcode 14.0+
- Swift 5.7+

### Installation - Quick Start (5 minutes)

**Option 1: Automated (Recommended)**

Run in terminal:
```bash
./create_xcode_project.sh
```
Then follow the Xcode wizard to create the project.

**Option 2: Manual Setup**

1. Open Xcode → Create a new Xcode project
2. Choose "iOS" → "App" → Name it `InvestmentApp`
3. Select SwiftUI as interface
4. Save in current directory
5. Import these files into your Xcode project:
   - `InvestmentAppApp.swift` (main entry point)
   - `ContentView.swift` (tab bar)
   - All files in `Views/` folder
   - All files in `Models/` folder
   - All files in `Managers/` folder
   - `Info.plist`

6. Build and Run (⌘ + R)

📖 **Detailed instructions**: See `SETUP_INSTRUCTIONS.md`

### Usage
1. Start with the **Portfolio** tab to view available stocks
2. Tap on any stock to buy or sell shares
3. Track your performance in the **Profile** tab
4. Learn investing concepts in the **Learn** tab
5. Read articles in the **Articles** tab to expand your knowledge

## Project Structure

```
InvestmentApp/
├── InvestmentAppApp.swift          # Main app entry point
├── ContentView.swift               # Tab bar view
├── Views/
│   ├── PortfolioView.swift        # Portfolio and trading interface
│   ├── LearnView.swift            # Learning path with lessons
│   ├── ArticlesView.swift         # Article reader
│   └── ProfileView.swift          # User stats and holdings
├── Models/
│   └── Stock.swift                # Stock and transaction models
└── Managers/
    └── PortfolioManager.swift     # Portfolio state management
```

## Technologies Used
- SwiftUI for modern declarative UI
- Swift Charts for graph visualizations
- Combine for reactive programming
- MVVM architecture pattern

## Features Overview

### Stock Trading
- Buy and sell stocks with virtual currency
- Real-time price calculations
- Quantity-based trading
- Transaction history

### Learning Path
- Step-by-step lessons with icons
- Progress tracking across modules
- Completion badges
- Interactive lessons (structure ready for content)

### Educational Content
- Expert-written articles on investing
- Reading time estimates
- Categorized content
- Beautiful card-based UI

### Portfolio Management
- Track total portfolio value
- View individual holdings performance
- See gain/loss percentages
- Visual portfolio allocation

## Future Enhancements
- [ ] Live market data integration
- [ ] More complex trading options (limit orders, stop-loss)
- [ ] Social features (leaderboards, sharing)
- [ ] Enhanced lesson content with videos
- [ ] Push notifications for price alerts
- [ ] Advanced analytics and insights

## License
This project is created for educational purposes.

