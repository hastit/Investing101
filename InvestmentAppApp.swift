import SwiftUI

@main
struct InvestmentAppApp: App {
    @StateObject private var portfolioManager = PortfolioManager()
    @StateObject private var bitcoinPriceService = BitcoinPriceService()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(portfolioManager)
                    .environmentObject(bitcoinPriceService)
                    .onAppear {
                        // Start Bitcoin price updates when app appears
                        bitcoinPriceService.fetchInitialPrice()
                        bitcoinPriceService.start()
                        // Inject service into portfolio manager
                        portfolioManager.bitcoinPriceService = bitcoinPriceService
                    }
                    .onDisappear {
                        // Stop updates when app disappears to save resources
                        bitcoinPriceService.stop()
                    }
            } else {
                ZStack {
                    // Ensure window background is dark
                    Color(red: 0.05, green: 0.08, blue: 0.15)
                        .ignoresSafeArea(.all)
                    
                    OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
                        .background(Color.clear)
                }
            }
        }
    }
}

