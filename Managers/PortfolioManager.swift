import Foundation
import Combine

class PortfolioManager: ObservableObject {
    @Published var holdings: [Holding] = []
    @Published var cash: Double = 10000.0  // Starting cash ($10,000 virtual money)
    @Published var transactions: [Transaction] = []
    
    // Learning System
    @Published var totalXP: Int = 0
    @Published var currentRank: String = "Beginner"
    
    // BitcoinPriceService injection for real-time BTC prices
    var bitcoinPriceService: BitcoinPriceService?
    
    var totalValue: Double {
        let holdingsValue = holdings.reduce(0) { total, holding in
            let currentPrice = getCurrentPrice(for: holding.stockSymbol)
            return total + holding.currentValue(currentPrice: currentPrice)
        }
        return cash + holdingsValue
    }
    
    func addXP(_ xp: Int) {
        totalXP += xp
        updateRank()
    }
    
    func rewardMoney(_ amount: Double) {
        cash += amount
    }
    
    private func updateRank() {
        // Rank system based on total XP
        switch totalXP {
        case 0..<100:
            currentRank = "Beginner"
        case 100..<300:
            currentRank = "Apprentice"
        case 300..<500:
            currentRank = "Investor"
        case 500..<1000:
            currentRank = "Expert"
        default:
            currentRank = "Master"
        }
    }
    
    func getCurrentPrice(for symbol: String) -> Double {
        // Use real-time Bitcoin price if available
        if symbol == "BTC", let btcPrice = bitcoinPriceService?.currentPrice, btcPrice > 0 {
            return btcPrice
        }
        // For other symbols, use the default data generator
        let data = StockDataGenerator.getChartData(for: symbol)
        return data.last ?? 0
    }
    
    func buyStock(symbol: String, quantity: Double, price: Double) -> Bool {
        let cost = quantity * price
        
        if cost > cash {
            return false // Not enough cash
        }
        
        // Check if we already own this stock
        if let index = holdings.firstIndex(where: { $0.stockSymbol == symbol }) {
            let totalQuantity = holdings[index].quantity + quantity
            let totalValue = (holdings[index].quantity * holdings[index].purchasePrice) + cost
            holdings[index].purchasePrice = totalValue / totalQuantity
            holdings[index].quantity = totalQuantity
        } else {
            holdings.append(Holding(stockSymbol: symbol, quantity: quantity, purchasePrice: price))
        }
        
        cash -= cost
        
        let transaction = Transaction(
            stockSymbol: symbol,
            type: .buy,
            quantity: quantity,
            price: price
        )
        transactions.append(transaction)
        
        return true
    }
    
    func sellStock(symbol: String, quantity: Double, price: Double) -> Bool {
        guard let index = holdings.firstIndex(where: { $0.stockSymbol == symbol }) else {
            return false // Don't own this stock
        }
        
        guard holdings[index].quantity >= quantity else {
            return false // Not enough shares
        }
        
        let revenue = quantity * price
        cash += revenue
        
        holdings[index].quantity -= quantity
        
        if holdings[index].quantity <= 0.000001 { // Use small threshold for floating point comparison
            holdings.remove(at: index)
        }
        
        let transaction = Transaction(
            stockSymbol: symbol,
            type: .sell,
            quantity: quantity,
            price: price
        )
        transactions.append(transaction)
        
        return true
    }
    
    func getHolding(for symbol: String) -> Holding? {
        holdings.first { $0.stockSymbol == symbol }
    }
}

