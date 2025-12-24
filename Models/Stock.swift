import Foundation
import SwiftUI

struct Stock: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let name: String
    let color: String
    
    var chartData: [Double] {
        StockDataGenerator.getChartData(for: symbol)
    }
    
    init(id: UUID = UUID(), symbol: String, name: String, color: String) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.color = color
    }
}

struct StockDataGenerator {
    static func getChartData(for symbol: String) -> [Double] {
        let base: Double
        
        switch symbol {
        case "BTC": base = 45000.0
        case "GOLD": base = 1950.0
        case "OIL": base = 75.0
        case "AAPL": base = 175.0
        case "MSFT": base = 380.0
        default: base = 100.0
        }
        
        var data: [Double] = []
        var value = base
        
        for _ in 0..<30 {
            let change = Double.random(in: -0.02...0.02)
            value = value * (1 + change)
            data.append(value)
        }
        
        return data
    }
}

struct Holding: Identifiable, Codable {
    let id: UUID
    let stockSymbol: String
    var quantity: Int
    var purchasePrice: Double
    
    init(id: UUID = UUID(), stockSymbol: String, quantity: Int, purchasePrice: Double) {
        self.id = id
        self.stockSymbol = stockSymbol
        self.quantity = quantity
        self.purchasePrice = purchasePrice
    }
    
    func currentValue(currentPrice: Double) -> Double {
        Double(quantity) * currentPrice
    }
    
    func totalReturn(currentPrice: Double) -> Double {
        currentValue(currentPrice: currentPrice) - (Double(quantity) * purchasePrice)
    }
    
    func totalReturnPercent(currentPrice: Double) -> Double {
        ((currentPrice - purchasePrice) / purchasePrice) * 100
    }
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    let stockSymbol: String
    let type: TransactionType
    let quantity: Int
    let price: Double
    let totalAmount: Double
    let date: Date
    
    enum TransactionType: String, Codable {
        case buy, sell
    }
    
    init(id: UUID = UUID(), stockSymbol: String, type: TransactionType, quantity: Int, price: Double, date: Date = Date()) {
        self.id = id
        self.stockSymbol = stockSymbol
        self.type = type
        self.quantity = quantity
        self.price = price
        self.totalAmount = Double(quantity) * price
        self.date = date
    }
}

