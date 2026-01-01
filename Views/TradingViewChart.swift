import SwiftUI
import Charts

struct TradingViewChart: View {
    let stock: Stock
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var bitcoinPriceService: BitcoinPriceService
    @State private var selectedTimeframe: String = "1D"
    
    // Fixed window size for visible data points (like TradingView)
    private let visiblePointsCount = 50
    
    private var allChartData: [Double] {
        // Use real Bitcoin prices if stock is BTC and service is available
        if stock.symbol == "BTC" && !bitcoinPriceService.priceHistory.isEmpty {
            return bitcoinPriceService.getChartData()
        }
        return stock.chartData
    }
    
    // Get last N points for fixed viewport (sliding window)
    private var chartData: [Double] {
        let data = allChartData
        guard data.count > visiblePointsCount else { return data }
        return Array(data.suffix(visiblePointsCount))
    }
    
    private var chartDataPoints: [(index: Int, price: Double)] {
        chartData.enumerated().map { (index, price) in
            (index: index, price: price)
        }
    }
    
    private var currentPriceValue: Double {
        if stock.symbol == "BTC" {
            return bitcoinPriceService.currentPrice > 0 ? bitcoinPriceService.currentPrice : (allChartData.last ?? 0)
        }
        return allChartData.last ?? 0
    }
    
    private var priceChange: (value: Double, percent: Double) {
        let data = allChartData
        guard data.count >= 2 else { return (0, 0) }
        let current = data.last ?? 0
        let previous = data[data.count - 2]
        let change = current - previous
        let percent = ((current - previous) / previous) * 100
        return (change, percent)
    }
    
    // Smooth Y-axis range with animation support - tight range to show price changes clearly
    private var priceRange: ClosedRange<Double> {
        guard !chartData.isEmpty else { return 0...100 }
        let minPrice = chartData.min() ?? 0
        let maxPrice = chartData.max() ?? 0
        let actualRange = maxPrice - minPrice
        
        // For Bitcoin, use a tighter range to show dollar-to-dollar changes
        if stock.symbol == "BTC" {
            // Use actual range or at least $10-20 range for visibility
            let range = max(actualRange, 20.0)
            // Small padding - just 2-3% to show price movements clearly
            let padding = range * 0.03
            return (minPrice - padding)...(maxPrice + padding)
        } else {
            // For other stocks, use percentage-based range
            let range = max(actualRange, maxPrice * 0.02)
            let padding = range * 0.08
            return (minPrice - padding)...(maxPrice + padding)
        }
    }
    
    // Calculate Y-axis values - show 5-6 evenly spaced price levels
    private var yAxisValues: [Double] {
        guard !chartData.isEmpty else { return [] }
        
        let minPrice = priceRange.lowerBound
        let maxPrice = priceRange.upperBound
        let range = maxPrice - minPrice
        
        // Target 5-6 labels for readability
        let targetLabels = 5
        let step = range / Double(targetLabels - 1)
        
        // Round step to a nice increment (e.g., 1, 5, 10, 50, 100)
        let roundedStep: Double
        if step < 2 {
            roundedStep = 1.0  // $1 increments for small ranges
        } else if step < 5 {
            roundedStep = 2.0  // $2 increments
        } else if step < 10 {
            roundedStep = 5.0  // $5 increments
        } else if step < 50 {
            roundedStep = 10.0 // $10 increments
        } else {
            roundedStep = 50.0 // $50 increments for large ranges
        }
        
        // Generate evenly spaced values
        var values: [Double] = []
        var current = ceil(minPrice / roundedStep) * roundedStep
        
        while current <= maxPrice && values.count < targetLabels + 1 {
            values.append(current)
            current += roundedStep
        }
        
        return values
    }
    
    // Fixed X-axis domain to prevent zooming
    private var xAxisDomain: ClosedRange<Int> {
        return 0...(max(visiblePointsCount - 1, chartData.count - 1))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with symbol and price
            chartHeader
            
            // Main chart area with fixed viewport
            ZStack {
                // Chart background
                Color(.systemBackground)
                
                // Chart with overlay
                chartWithOverlay
                    .frame(height: 320)
            }
            
            // Time axis at bottom
            timeAxis
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
    
    // MARK: - Chart Header
    private var chartHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(stock.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text("/ USD")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Circle()
                        .fill(priceChange.percent >= 0 ? Color.green : Color.red)
                        .frame(width: 6, height: 6)
                }
                
                Text(stock.name)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatPrice(currentPriceValue))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Text(formatChange(priceChange.value))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(priceChange.percent >= 0 ? .green : .red)
                    
                    Text(formatPercent(priceChange.percent))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(priceChange.percent >= 0 ? .green : .red)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Chart with Overlay
    @ViewBuilder
    private var chartWithOverlay: some View {
        if stock.symbol == "BTC" {
            Chart(chartDataPoints, id: \.index) { point in
                LineMark(
                    x: .value("Index", point.index),
                    y: .value("Price", point.price)
                )
                .foregroundStyle(strokeColor)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
            }
            .chartXScale(domain: xAxisDomain)
            .chartYScale(domain: priceRange)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .trailing, values: yAxisValues) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.2))
                    
                    if let price = value.as(Double.self) {
                        AxisValueLabel {
                            Text(formatPriceForAxis(price))
                                .font(.system(size: 11, weight: .medium, design: .default))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea.background(Color.clear)
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    currentPriceIndicatorOverlay(proxy: proxy, geometry: geometry)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        } else {
            Chart(chartDataPoints, id: \.index) { point in
                LineMark(
                    x: .value("Index", point.index),
                    y: .value("Price", point.price)
                )
                .foregroundStyle(strokeColor)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .interpolationMethod(.catmullRom)
            }
            .chartXScale(domain: xAxisDomain)
            .chartYScale(domain: priceRange)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks(position: .trailing, values: .automatic(desiredCount: 5)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(Color.gray.opacity(0.2))
                    
                    if let price = value.as(Double.self) {
                        AxisValueLabel {
                            Text(formatPriceForAxis(price))
                                .font(.system(size: 11, weight: .medium, design: .default))
                                .foregroundStyle(Color.gray)
                        }
                    }
                }
            }
            .chartPlotStyle { plotArea in
                plotArea.background(Color.clear)
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    currentPriceIndicatorOverlay(proxy: proxy, geometry: geometry)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Current Price Indicator Overlay (moves along X and Y axis)
    private func currentPriceIndicatorOverlay(proxy: ChartProxy, geometry: GeometryProxy) -> some View {
        guard !chartData.isEmpty else { return AnyView(EmptyView()) }
        
        let plotFrame = geometry[proxy.plotFrame!]
        let lastIndex = chartData.count - 1
        
        // Get X position for the last data point (right edge)
        guard let xPosition = proxy.position(forX: lastIndex) else {
            return AnyView(EmptyView())
        }
        
        // Get Y position for current price
        guard let yPosition = proxy.position(forY: currentPriceValue) else {
            return AnyView(EmptyView())
        }
        
        let isPositive = priceChange.percent >= 0
        
        // Convert to geometry coordinates
        let xPos = plotFrame.minX + xPosition
        let yPos = plotFrame.minY + yPosition
        let lineWidth = plotFrame.width - (xPos - plotFrame.minX)
        
        return AnyView(
            ZStack {
                // Horizontal line extending from current price to right edge
                Rectangle()
                    .fill(isPositive ? Color.green.opacity(0.25) : Color.red.opacity(0.25))
                    .frame(width: lineWidth, height: 1)
                    .position(x: (xPos + plotFrame.maxX) / 2, y: yPos)
                
                // Price indicator box at the right edge
                HStack(spacing: 4) {
                    // Small dot on the line
                    Circle()
                        .fill(strokeColor)
                        .frame(width: 6, height: 6)
                    
                    // Price label
                    Text(formatPrice(currentPriceValue))
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundStyle(Color.primary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isPositive ? Color.green.opacity(0.4) : Color.red.opacity(0.4), lineWidth: 1)
                )
                .position(x: plotFrame.maxX - 35, y: yPos)
            }
            .animation(.easeOut(duration: 0.3), value: currentPriceValue)
        )
    }
    
    // MARK: - Time Axis
    private var timeAxis: some View {
        HStack(spacing: 0) {
            let timeLabels = getTimeLabels()
            ForEach(Array(timeLabels.enumerated()), id: \.offset) { index, label in
                Spacer()
                Text(label)
                    .font(.system(size: 11, weight: .medium, design: .default))
                    .foregroundStyle(Color.gray)
                if index < timeLabels.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(height: 32)
    }
    
    private func getTimeLabels() -> [String] {
        if stock.symbol == "BTC" && !bitcoinPriceService.priceHistory.isEmpty {
            let history = bitcoinPriceService.priceHistory
            guard history.count > 0 else { return ["--:--", "--:--", "--:--", "--:--"] }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let labelCount = 4
            let visibleHistory = history.suffix(min(visiblePointsCount, history.count))
            let historyArray = Array(visibleHistory)
            
            if historyArray.count <= labelCount {
                return historyArray.map { formatter.string(from: $0.timestamp) }
            }
            
            var labels: [String] = []
            let step = (historyArray.count - 1) / (labelCount - 1)
            
            for i in 0..<labelCount {
                let index = min(i * step, historyArray.count - 1)
                labels.append(formatter.string(from: historyArray[index].timestamp))
            }
            
            return labels
        } else {
            return formatTimeLabelForNonBTC()
        }
    }
    
    private func formatTimeLabelForNonBTC() -> [String] {
        let now = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return (0..<4).map { i in
            let minutesToSubtract = Int(Double(3 - i) * 10)
            if let time = calendar.date(byAdding: .minute, value: -minutesToSubtract, to: now) {
                return formatter.string(from: time)
            }
            return "--:--"
        }
    }
    
    // MARK: - Helper Functions
    private var strokeColor: Color {
        Color(hex: stock.color) ?? .blue
    }
    
    private func formatPrice(_ value: Double) -> String {
        // For Bitcoin prices (typically 40k-100k), show with commas, no decimals
        if stock.symbol == "BTC" {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
            if let formatted = formatter.string(from: NSNumber(value: value)) {
                return formatted
            }
            return String(format: "%.0f", value)
        } else if value >= 1000 {
            return String(format: "%.0f", value)
        } else if value >= 1 {
            return String(format: "%.2f", value)
        } else {
            return String(format: "%.4f", value)
        }
    }
    
    private func formatPriceForAxis(_ value: Double) -> String {
        // Compact format for Y-axis
        return formatPrice(value)
    }
    
    private func formatChange(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return String(format: "%@$%.2f", sign, value)
    }
    
    private func formatPercent(_ value: Double) -> String {
        let sign = value >= 0 ? "+" : ""
        return String(format: "%@%.2f%%", sign, value)
    }
}
