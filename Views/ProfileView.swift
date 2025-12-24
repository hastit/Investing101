import SwiftUI
import Charts

struct ProfileView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                        
                        Text("Investor")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Portfolio Value")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("$\(String(format: "%.2f", portfolioManager.totalValue))")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding()
                    
                    // Stats cards
                    VStack(spacing: 12) {
                        StatCard(
                            title: "Available Cash",
                            value: "$\(String(format: "%.2f", portfolioManager.cash))",
                            icon: "dollarsign.circle.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Invested Amount",
                            value: "$\(String(format: "%.2f", investedAmount))",
                            icon: "chart.bar.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Total Gain/Loss",
                            value: "$\(String(format: "%.2f", totalGainLoss))",
                            icon: "arrow.up.right.circle.fill",
                            color: totalGainLoss >= 0 ? .green : .red
                        )
                        
                        StatCard(
                            title: "Number of Holdings",
                            value: "\(portfolioManager.holdings.count)",
                            icon: "briefcase.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    // Holdings section
                    if !portfolioManager.holdings.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your Holdings")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(portfolioManager.holdings) { holding in
                                HoldingRowView(holding: holding)
                            }
                            
                            // Portfolio allocation chart
                            if holdingsValue > 0 {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Portfolio Allocation")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    Chart {
                                        ForEach(allocationData, id: \.symbol) { item in
                                            SectorMark(
                                                angle: .value("Value", item.value),
                                                innerRadius: .ratio(0.5),
                                                angularInset: 3
                                            )
                                            .foregroundStyle(Color(hex: item.color) ?? .blue)
                                            .annotation(position: .overlay) {
                                                if item.percentage > 8 {
                                                    Text("\(Int(item.percentage))%")
                                                        .font(.caption)
                                                        .fontWeight(.bold)
                                                }
                                            }
                                        }
                                    }
                                    .frame(height: 250)
                                    .padding()
                                    
                                    // Legend
                                    VStack(spacing: 8) {
                                        ForEach(allocationData, id: \.symbol) { item in
                                            HStack {
                                                Circle()
                                                    .fill(Color(hex: item.color) ?? .blue)
                                                    .frame(width: 16, height: 16)
                                                
                                                Text(item.symbol)
                                                    .font(.caption)
                                                
                                                Spacer()
                                                
                                                Text("\(String(format: "%.1f", item.percentage))%")
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.pie")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Holdings Yet")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Start investing to see your portfolio allocation here")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Recent transactions
                    if !portfolioManager.transactions.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Transactions")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(Array(portfolioManager.transactions.prefix(5))) { transaction in
                                TransactionRowView(transaction: transaction)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
        }
    }
    
    private var investedAmount: Double {
        portfolioManager.holdings.reduce(0) { total, holding in
            let currentPrice = portfolioManager.getCurrentPrice(for: holding.stockSymbol)
            return total + holding.currentValue(currentPrice: currentPrice)
        }
    }
    
    private var holdingsValue: Double {
        investedAmount
    }
    
    private var totalGainLoss: Double {
        portfolioManager.holdings.reduce(0) { total, holding in
            let currentPrice = portfolioManager.getCurrentPrice(for: holding.stockSymbol)
            return total + holding.totalReturn(currentPrice: currentPrice)
        }
    }
    
    private var allocationData: [AllocationItem] {
        guard holdingsValue > 0 else { return [] }
        
        var items: [AllocationItem] = []
        let stocks = [
            Stock(symbol: "GOLD", name: "Gold", color: "FFFF00"),
            Stock(symbol: "OIL", name: "Crude Oil", color: "000000"),
            Stock(symbol: "BTC", name: "Bitcoin", color: "F7931A"),
            Stock(symbol: "AAPL", name: "Apple Inc.", color: "A8A8A8"),
            Stock(symbol: "MSFT", name: "Microsoft", color: "F25022")
        ]
        
        for stock in stocks {
            if let holding = portfolioManager.getHolding(for: stock.symbol) {
                let currentPrice = portfolioManager.getCurrentPrice(for: stock.symbol)
                let value = holding.currentValue(currentPrice: currentPrice)
                let percentage = (value / holdingsValue) * 100
                
                if percentage > 0.5 { // Only show if > 0.5%
                    items.append(AllocationItem(
                        symbol: stock.symbol,
                        value: value,
                        percentage: percentage,
                        color: stock.color
                    ))
                }
            }
        }
        
        return items.sorted { $0.percentage > $1.percentage }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct HoldingRowView: View {
    let holding: Holding
    @EnvironmentObject var portfolioManager: PortfolioManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(holding.stockSymbol)
                        .font(.headline)
                    
                    Text("\(holding.quantity) shares @ $\(String(format: "%.2f", holding.purchasePrice))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", currentValue))")
                        .font(.headline)
                    
                    Text(totalReturnString)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(totalReturn >= 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    private var currentValue: Double {
        let price = portfolioManager.getCurrentPrice(for: holding.stockSymbol)
        return holding.currentValue(currentPrice: price)
    }
    
    private var totalReturn: Double {
        let price = portfolioManager.getCurrentPrice(for: holding.stockSymbol)
        return holding.totalReturn(currentPrice: price)
    }
    
    private var totalReturnString: String {
        let percent = holding.totalReturnPercent(currentPrice: portfolioManager.getCurrentPrice(for: holding.stockSymbol))
        return "\(totalReturn >= 0 ? "+" : "")\(String(format: "%.2f", percent))%"
    }
}

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: transaction.type == .buy ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                        .foregroundColor(transaction.type == .buy ? .green : .red)
                    
                    Text(transaction.stockSymbol)
                        .font(.headline)
                }
                
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(transaction.type == .buy ? "+" : "-")\(transaction.quantity)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(transaction.type == .buy ? .green : .red)
                
                Text("$\(String(format: "%.2f", transaction.price))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct AllocationItem {
    let symbol: String
    let value: Double
    let percentage: Double
    let color: String
}

