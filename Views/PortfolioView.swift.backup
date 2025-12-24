import SwiftUI
import Charts

struct PortfolioView: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    @State private var showTradeSheet = false
    @State private var selectedStockIndex = 0
    @State private var selectedTimeframe = "1D"
    @State private var showStockInfo = false
    @State private var showDetailedChart = false
    
    let stocks = [
        Stock(symbol: "GOLD", name: "Gold", color: "FFD700"),
        Stock(symbol: "OIL", name: "Crude Oil", color: "1C1C1E"),
        Stock(symbol: "BTC", name: "Bitcoin", color: "F7931A"),
        Stock(symbol: "AAPL", name: "Apple Inc.", color: "A8A8A8"),
        Stock(symbol: "MSFT", name: "Microsoft", color: "00A4EF")
    ]
    
    var selectedStock: Stock {
        stocks[selectedStockIndex]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Stock Selection Tabs with Images
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(stocks.enumerated()), id: \.element.id) { index, stock in
                                StockTabButton(
                                    stock: stock,
                                    isSelected: index == selectedStockIndex,
                                    action: { selectedStockIndex = index }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 8)
                    
                    // Stock Info Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color(hex: selectedStock.color) ?? .blue, Color(hex: selectedStock.color)?.opacity(0.6) ?? .blue.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text(selectedStock.symbol.prefix(1))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(selectedStock.name)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(selectedStock.symbol)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: { showStockInfo.toggle() }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Current Price")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("$\(String(format: "%.2f", selectedStock.chartData.last ?? 0))")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("24h Change")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                let change = getPriceChange()
                                Text(change >= 0 ? "+\(String(format: "%.2f", change))%" : "\(String(format: "%.2f", change))%")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(change >= 0 ? .green : .red)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Detailed Chart
                    VStack(spacing: 12) {
                        // Timeframe Selector
                        HStack {
                            ForEach(["1D", "1W", "1M", "1Y"], id: \.self) { timeframe in
                                Button(action: { selectedTimeframe = timeframe }) {
                                    Text(timeframe)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(selectedTimeframe == timeframe ? Color.blue : Color(.systemGray6))
                                        .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                                        .cornerRadius(10)
                                }
                            }
                            
                            Spacer()
                            
                            // Fullscreen Chart Button
                            Button(action: { showDetailedChart = true }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    Text("Fullscreen")
                                }
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Chart
                        Chart {
                            ForEach(Array(selectedStock.chartData.enumerated()), id: \.offset) { index, value in
                                LineMark(
                                    x: .value("Time", index),
                                    y: .value("Price", value)
                                )
                                .foregroundStyle(Color(hex: selectedStock.color) ?? .blue)
                                .lineStyle(StrokeStyle(lineWidth: 2))
                                .interpolationMethod(.catmullRom)
                                
                                AreaMark(
                                    x: .value("Time", index),
                                    y: .value("Price", value)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            (Color(hex: selectedStock.color) ?? .blue).opacity(0.4),
                                            (Color(hex: selectedStock.color) ?? .blue).opacity(0.05)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 250)
                        .chartXAxis(.hidden)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Your Holdings Card
                    if let holding = portfolioManager.getHolding(for: selectedStock.symbol) {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Your Holdings")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("PROFIT")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(havingProfit ? Color.green : Color.red)
                                    .cornerRadius(6)
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(holding.quantity) shares")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    Text("Avg: $\(String(format: "%.2f", holding.purchasePrice))")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    Text("$\(String(format: "%.2f", currentValue))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    let percent = holding.totalReturnPercent(currentPrice: portfolioManager.getCurrentPrice(for: selectedStock.symbol))
                                    Text(percent >= 0 ? "+\(String(format: "%.2f", percent))%" : "\(String(format: "%.2f", percent))%")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(percent >= 0 ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal)
                    }
                    
                    // Portfolio Summary Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "briefcase.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            
                            Text("Portfolio Summary")
                                .font(.headline)
                        }
                        
                        Divider()
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Total Value")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", portfolioManager.totalValue))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                Text("Available Cash")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("$\(String(format: "%.2f", portfolioManager.cash))")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: { showTradeSheet = true }) {
                            HStack {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.title3)
                                Text("Trade")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(16)
                        }
                        
                        Button(action: { 
                            // Add to watchlist
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .font(.title3)
                                Text("Add to Watchlist")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32) // Extra bottom padding for tab bar
                }
                .padding(.top, 8)
            }
            .navigationTitle("Portfolio")
            .sheet(isPresented: $showStockInfo) {
                StockInfoSheet(stock: selectedStock)
            }
            .fullScreenCover(isPresented: $showDetailedChart) {
                ProfessionalChartView(stock: selectedStock)
            }
            .sheet(isPresented: $showTradeSheet) {
                TradeSheet(stock: selectedStock)
                    .environmentObject(portfolioManager)
            }
        }
    }
    
    private func getPriceChange() -> Double {
        let data = selectedStock.chartData
        guard data.count >= 2 else { return 0 }
        let current = data.last ?? 0
        let previous = data[data.count - 2]
        return ((current - previous) / previous) * 100
    }
    
    private var currentValue: Double {
        let price = portfolioManager.getCurrentPrice(for: selectedStock.symbol)
        if let holding = portfolioManager.getHolding(for: selectedStock.symbol) {
            return holding.currentValue(currentPrice: price)
        }
        return 0
    }
    
    private var havingProfit: Bool {
        let price = portfolioManager.getCurrentPrice(for: selectedStock.symbol)
        if let holding = portfolioManager.getHolding(for: selectedStock.symbol) {
            return holding.totalReturn(currentPrice: price) >= 0
        }
        return false
    }
}

// MARK: - Stock Tab Button with Circle Image
struct StockTabButton: View {
    let stock: Stock
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Circular image-like icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: stock.color) ?? .blue,
                                    Color(hex: stock.color)?.opacity(0.7) ?? .blue.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isSelected ? 56 : 50, height: isSelected ? 56 : 50)
                    
                    Text(stock.symbol.prefix(2))
                        .font(.system(size: isSelected ? 18 : 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 2) {
                    Text(stock.symbol)
                        .font(.system(size: 12, weight: .semibold))
                    
                    Text("$\(String(format: "%.0f", stock.chartData.last ?? 0))")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .cornerRadius(16)
        }
    }
}

// MARK: - Stock Info Sheet
struct StockInfoSheet: View {
    let stock: Stock
    @Environment(\.dismiss) var dismiss
    
    var stockDescription: String {
        switch stock.symbol {
        case "GOLD":
            return "Gold is a precious metal used as a store of value and hedge against inflation. It's considered a safe investment during economic uncertainty."
        case "OIL":
            return "Crude oil is the most actively traded energy commodity. Price is affected by global supply, demand, and geopolitical events."
        case "BTC":
            return "Bitcoin is a decentralized digital currency known for high volatility. It's the first and largest cryptocurrency by market cap."
        case "AAPL":
            return "Apple Inc. designs and manufactures consumer electronics, software, and services. Its stock is heavily weighted in major indices."
        case "MSFT":
            return "Microsoft Corporation develops and supports software, services, and solutions. It's a leader in cloud computing and enterprise software."
        default:
            return "A diversified investment option."
        }
    }
    
    var riskLevel: String {
        switch stock.symbol {
        case "GOLD", "AAPL", "MSFT":
            return "Low to Medium"
        case "OIL":
            return "Medium to High"
        case "BTC":
            return "Very High"
        default:
            return "Unknown"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Circle()
                            .fill(Color(hex: stock.color) ?? .blue)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(stock.symbol)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(stock.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(stock.symbol)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Risk Level: \(riskLevel)")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About This Stock")
                            .font(.headline)
                        
                        Text(stockDescription)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Key Metrics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key Information")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Current Price:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", stock.chartData.last ?? 0))")
                                    .fontWeight(.semibold)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Risk Level:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(riskLevel)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.orange)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Suitable for:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Beginners" + (stock.symbol == "BTC" || stock.symbol == "OIL" ? " (High Risk)" : ""))
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Stock Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Professional Chart View
struct ProfessionalChartView: View {
    let stock: Stock
    @Environment(\.dismiss) var dismiss
    @State private var zoomLevel: Double = 1.0
    @State private var panOffset: Double = 0.0
    @State private var selectedTimeframe = "1D"
    @State private var dragOffset: Double = 0
    @State private var isDragging = false
    @State private var yAxisZoom: Double = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(stock.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(stock.symbol)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.2f", stock.chartData.last ?? 0))")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    let change = getPriceChange()
                    Text(change >= 0 ? "+\(String(format: "%.2f", change))%" : "\(String(format: "%.2f", change))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(change >= 0 ? .green : .red)
                }
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            Divider()
            
            // Timeframe Selector
            HStack(spacing: 12) {
                ForEach(["1D", "1W", "1M", "1Y"], id: \.self) { timeframe in
                    Button(action: { selectedTimeframe = timeframe }) {
                        Text(timeframe)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTimeframe == timeframe ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(selectedTimeframe == timeframe ? Color.blue : Color(.systemGray5))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Professional Chart
            GeometryReader { geometry in
                Chart {
                    ForEach(visibleData, id: \.index) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.index),
                            y: .value("Price", dataPoint.value)
                        )
                        .foregroundStyle(Color(hex: stock.color) ?? .blue)
                        .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.linear)
                    }
                }
                .chartYScale(domain: chartYRange)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 8)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(.systemGray3))
                        AxisTick(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(.systemGray4))
                        AxisValueLabel()
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundStyle(.primary)
                    }
                }
                .chartYAxis {
                    yAxisMarks
                }
                .chartPlotStyle { plotArea in
                    plotArea
                        .background(Color(.systemBackground))
                        .border(Color(.systemGray5))
                        .cornerRadius(8)
                }
                .gesture(panGesture)
                .gesture(yAxisZoomGesture)
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
            
            // Zoom Controls
            VStack(spacing: 8) {
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("X-Axis")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                Button(action: { 
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        zoomLevel = min(zoomLevel + 0.2, 3.0)
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.callout)
                                        .foregroundColor(zoomLevel >= 3.0 ? .gray : .blue)
                                }
                                .disabled(zoomLevel >= 3.0)
                                
                                Text("\(Int(zoomLevel * 100))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 50)
                                
                                Button(action: { 
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        zoomLevel = max(zoomLevel - 0.2, 0.5)
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .font(.callout)
                                        .foregroundColor(zoomLevel <= 0.5 ? .gray : .blue)
                                }
                                .disabled(zoomLevel <= 0.5)
                            }
                        }
                        
                        Divider()
                            .frame(height: 40)
                        
                        VStack(spacing: 4) {
                            Text("Y-Axis")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 12) {
                                Button(action: { 
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        yAxisZoom = min(yAxisZoom + 0.2, 5.0)
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.callout)
                                        .foregroundColor(yAxisZoom >= 5.0 ? .gray : .blue)
                                }
                                .disabled(yAxisZoom >= 5.0)
                                
                                Text("\(Int(yAxisZoom * 100))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(minWidth: 50)
                                
                                Button(action: { 
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        yAxisZoom = max(yAxisZoom - 0.2, 0.3)
                                    }
                                }) {
                                    Image(systemName: "plus")
                                        .font(.callout)
                                        .foregroundColor(yAxisZoom <= 0.3 ? .gray : .blue)
                                }
                                .disabled(yAxisZoom <= 0.3)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { 
                            withAnimation(.easeInOut(duration: 0.3)) {
                                zoomLevel = 1.0
                                panOffset = 0.0
                                yAxisZoom = 1.0
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    Text("Horizontal drag: Pan X | Vertical drag: Zoom Y | Pinch: Zoom X")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .background(Color(.systemGray6))
        .gesture(
            MagnificationGesture()
                .onChanged { scale in
                    let baseScale: Double = 1.0
                    let newZoom = zoomLevel * (Double(scale) / baseScale)
                    zoomLevel = min(max(newZoom, 0.5), 3.0)
                }
        )
    }
    
    private var visibleData: [(index: Int, value: Double)] {
        let data = stock.chartData
        let totalPoints = Double(data.count)
        let visiblePoints = totalPoints / zoomLevel
        let start = max(0.0, panOffset)
        let end = min(totalPoints, start + visiblePoints)
        
        let startIndex = Int(start)
        let endIndex = min(Int(end), data.count)
        
        return Array(data.enumerated()
            .filter { $0.offset >= startIndex && $0.offset <= endIndex }
            .map { (index: $0.offset, value: $0.element) }
        )
    }
    
    private var yAxisMarks: some AxisContent {
        AxisMarks(position: .trailing, values: .automatic(desiredCount: 8)) { value in
            AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                .foregroundStyle(Color(.systemGray3))
            AxisValueLabel {
                if let val = value.as(Double.self) {
                    Text(formatPrice(val))
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = value.translation.width
                let sensitivity = 6.0
                let maxOffset = Double(stock.chartData.count) * (zoomLevel - 1.0) * 0.5
                let newOffset = panOffset - (Double(delta) / sensitivity)
                panOffset = min(max(newOffset, -maxOffset), maxOffset)
            }
    }
    
    private var yAxisZoomGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let delta = -value.translation.height
                let sensitivity = 100.0
                let newZoom = yAxisZoom + (delta / sensitivity)
                yAxisZoom = min(max(newZoom, 0.3), 5.0)
            }
    }
    
    private var chartYRange: ClosedRange<Double> {
        let data = stock.chartData
        guard !data.isEmpty else { return 0...100 }
        
        let minValue = data.min() ?? 0
        let maxValue = data.max() ?? 100
        let range = maxValue - minValue
        let center = (minValue + maxValue) / 2
        let newRange = range / yAxisZoom
        
        return (center - newRange / 2)...(center + newRange / 2)
    }
    
    private func formatPrice(_ value: Double) -> String {
        if value >= 1000 {
            return "$\(String(format: "%.0f", value))"
        } else if value >= 1 {
            return String(format: "$%.2f", value)
        } else {
            return String(format: "$%.4f", value)
        }
    }
    
    private func getPriceChange() -> Double {
        let data = stock.chartData
        guard data.count >= 2 else { return 0 }
        let current = data.last ?? 0
        let previous = data[data.count - 2]
        return ((current - previous) / previous) * 100
    }
}

// MARK: - Trade Sheet
struct TradeSheet: View {
    @EnvironmentObject var portfolioManager: PortfolioManager
    let stock: Stock
    @Environment(\.dismiss) var dismiss
    @State private var quantity: String = "1"
    @State private var tradeType: TradeType = .buy
    
    enum TradeType {
        case buy, sell
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Price")
                        Spacer()
                        Text("$\(String(format: "%.2f", price))")
                            .fontWeight(.semibold)
                    }
                    
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("$\(String(format: "%.2f", totalPrice))")
                            .fontWeight(.semibold)
                    }
                    
                    Picker("Action", selection: $tradeType) {
                        Text("Buy").tag(TradeType.buy)
                        Text("Sell").tag(TradeType.sell)
                    }
                    
                    TextField("Quantity", text: $quantity)
                        .keyboardType(.numberPad)
                }
                
                Section {
                    if let holding = portfolioManager.getHolding(for: stock.symbol) {
                        Text("Current Holdings: \(holding.quantity) shares")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Trade \(stock.symbol)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Confirm") {
                        executeTrade()
                    }
                    .disabled(!canTrade)
                }
            }
        }
    }
    
    private var price: Double {
        stock.chartData.last ?? 0
    }
    
    private var quantityValue: Int {
        Int(quantity) ?? 0
    }
    
    private var totalPrice: Double {
        Double(quantityValue) * price
    }
    
    private var canTrade: Bool {
        guard quantityValue > 0 else { return false }
        
        if tradeType == .buy {
            return totalPrice <= portfolioManager.cash
        } else {
            guard let holding = portfolioManager.getHolding(for: stock.symbol) else {
                return false
            }
            return quantityValue <= holding.quantity
        }
    }
    
    private func executeTrade() {
        if tradeType == .buy {
            let success = portfolioManager.buyStock(
                symbol: stock.symbol,
                quantity: quantityValue,
                price: price
            )
            if success {
                dismiss()
            }
        } else {
            let success = portfolioManager.sellStock(
                symbol: stock.symbol,
                quantity: quantityValue,
                price: price
            )
            if success {
                dismiss()
            }
        }
    }
}

// MARK: - Color Hex Extension
extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
