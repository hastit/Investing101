import Foundation
import Combine

class PortfolioManager: ObservableObject {
    @Published var holdings: [Holding] = []
    @Published var cash: Double = 10000.0  // Starting cash
    @Published var transactions: [Transaction] = []
    
    var totalValue: Double {
        let holdingsValue = holdings.reduce(0) { total, holding in
            let currentPrice = getCurrentPrice(for: holding.stockSymbol)
            return total + holding.currentValue(currentPrice: currentPrice)
        }
        return cash + holdingsValue
    }
    
    func getCurrentPrice(for symbol: String) -> Double {
        let data = StockDataGenerator.getChartData(for: symbol)
        return data.last ?? 0
    }
    
    func buyStock(symbol: String, quantity: Int, price: Double) -> Bool {
        let cost = Double(quantity) * price
        
        if cost > cash {
            return false // Not enough cash
        }
        
        // Check if we already own this stock
        if let index = holdings.firstIndex(where: { $0.stockSymbol == symbol }) {
            let totalQuantity = holdings[index].quantity + quantity
            let totalValue = (Double(holdings[index].quantity) * holdings[index].purchasePrice) + cost
            holdings[index].purchasePrice = totalValue / Double(totalQuantity)
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
    
    func sellStock(symbol: String, quantity: Int, price: Double) -> Bool {
        guard let index = holdings.firstIndex(where: { $0.stockSymbol == symbol }) else {
            return false // Don't own this stock
        }
        
        guard holdings[index].quantity >= quantity else {
            return false // Not enough shares
        }
        
        let revenue = Double(quantity) * price
        cash += revenue
        
        holdings[index].quantity -= quantity
        
        if holdings[index].quantity == 0 {
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

