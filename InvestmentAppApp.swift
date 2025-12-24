import SwiftUI

@main
struct InvestmentAppApp: App {
    @StateObject private var portfolioManager = PortfolioManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(portfolioManager)
        }
    }
}

