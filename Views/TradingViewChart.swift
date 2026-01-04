import SwiftUI
import Charts

struct TradingViewChart: View {
    let stock: Stock
    @EnvironmentObject var bitcoinPriceService: BitcoinPriceService
    @State private var selectedTimeframe: String = "1D"
    
    // Fixed window size for visible data points (like TradingView)
    private let visiblePointsCount = 50
    
    private var allChartData: [Double] {
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
        // Safety: prevent division by zero
        guard previous != 0 else { return (change, 0) }
        let percent = ((current - previous) / previous) * 100
        return (change, percent.isFinite && !percent.isNaN ? percent : 0)
    }
    
    // TradingView-style stable Y-axis range with margins
    private var priceRange: ClosedRange<Double> {
        guard !chartData.isEmpty else { return 0...100 }
        let minPrice = chartData.min() ?? 0
        let maxPrice = chartData.max() ?? 0
        let actualRange = maxPrice - minPrice
        
        // Safety check: if all prices are the same, create a small range
        guard actualRange > 0 && maxPrice > 0 else {
            let center = maxPrice > 0 ? maxPrice : 100.0
            return (center - 5.0)...(center + 5.0)
        }
        
        // TradingView default: ~10% margins for stability
        let range = max(actualRange, maxPrice * 0.01)
        let margin = range * 0.1
        
        return (minPrice - margin)...(maxPrice + margin)
    }
    
    // TradingView-style Y-axis values - automatic, evenly spaced
    private var yAxisValues: [Double] {
        guard !chartData.isEmpty else { return [] }
        
        let minPrice = priceRange.lowerBound
        let maxPrice = priceRange.upperBound
        let range = maxPrice - minPrice
        
        // Safety check: handle zero or invalid range
        guard range > 0 && range.isFinite && !range.isNaN else {
            let center = maxPrice > 0 ? maxPrice : 100.0
            return [center - 5, center, center + 5]
        }
        
        // Calculate optimal step size
        let targetSteps = 5.0
        let rawStep = range / targetSteps
        
        // Safety check: ensure rawStep is valid
        guard rawStep > 0 && rawStep.isFinite && !rawStep.isNaN else {
            let step = range / 5.0
            var values: [Double] = []
            var current = minPrice
            while current <= maxPrice && values.count < 7 {
                values.append(current)
                current += step
            }
            return values
        }
        
        // Round to nice increments (safe logarithm calculation)
        let logValue = log10(rawStep)
        guard logValue.isFinite && !logValue.isNaN else {
            // Fallback to simple division
            let step = range / 5.0
            var values: [Double] = []
            var current = ceil(minPrice / step) * step
            while current <= maxPrice && values.count < 7 {
                values.append(current)
                current += step
            }
            return values
        }
        
        let magnitude = pow(10.0, floor(logValue))
        guard magnitude > 0 && magnitude.isFinite && !magnitude.isNaN else {
            let step = range / 5.0
            var values: [Double] = []
            var current = ceil(minPrice / step) * step
            while current <= maxPrice && values.count < 7 {
                values.append(current)
                current += step
            }
            return values
        }
        
        let normalized = rawStep / magnitude
        let rounded: Double
        
        if normalized <= 1.0 {
            rounded = 1.0
        } else if normalized <= 2.0 {
            rounded = 2.0
        } else if normalized <= 5.0 {
            rounded = 5.0
        } else {
            rounded = 10.0
        }
        
        let step = rounded * magnitude
        guard step > 0 && step.isFinite && !step.isNaN else {
            let simpleStep = range / 5.0
            var values: [Double] = []
            var current = ceil(minPrice / simpleStep) * simpleStep
            while current <= maxPrice && values.count < 7 {
                values.append(current)
                current += simpleStep
            }
            return values
        }
        
        // Generate evenly spaced values
        var values: [Double] = []
        var current = ceil(minPrice / step) * step
        
        while current <= maxPrice && values.count < 7 {
            values.append(current)
            current += step
            // Safety: prevent infinite loops
            if values.count > 10 {
                break
            }
        }
        
        return values.isEmpty ? [minPrice, maxPrice] : values
    }
    
    // Fixed X-axis domain
    private var xAxisDomain: ClosedRange<Int> {
        return 0...(max(visiblePointsCount - 1, chartData.count - 1))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            chartHeader
            
            // Chart area
            chartArea
                .frame(height: 320)
            
            // Time axis
            timeAxis
        }
        .background(Color.white)
        .cornerRadius(16)
    }
    
    // MARK: - Chart Header
    private var chartHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(stock.symbol)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text("/ USD")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Circle()
                        .fill(priceChange.percent >= 0 ? Color.green : Color.red)
                        .frame(width: 6, height: 6)
                }
                
                Text(stock.name)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(formatPrice(currentPriceValue))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
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
        .background(Color.white)
    }
    
    // MARK: - Chart Area
    private var chartArea: some View {
        Chart(chartDataPoints, id: \.index) { point in
            LineMark(
                x: .value("Index", point.index),
                y: .value("Price", point.price)
            )
            .foregroundStyle(Color(red: 0.16, green: 0.38, blue: 1.0)) // TradingView blue
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.linear)
        }
        .chartXScale(domain: xAxisDomain)
        .chartYScale(domain: priceRange)
        .chartXAxis {
            // Vertical grid lines - TradingView style
            AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color(red: 0.77, green: 0.80, blue: 0.81, opacity: 0.25))
            }
        }
        .chartYAxis {
            // Horizontal grid lines and price labels - TradingView style
            AxisMarks(position: .trailing, values: yAxisValues) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    .foregroundStyle(Color(red: 0.77, green: 0.80, blue: 0.81, opacity: 0.3))
                
                if let price = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatPriceForAxis(price))
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13)) // TradingView text color
                    }
                }
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.background(Color.white)
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                priceLineOverlay(proxy: proxy, geometry: geometry)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    // MARK: - Price Line Overlay (last price indicator)
    private func priceLineOverlay(proxy: ChartProxy, geometry: GeometryProxy) -> some View {
        guard !chartData.isEmpty,
              let plotFrameAnchor = proxy.plotFrame else {
            return AnyView(EmptyView())
        }
        
        let plotFrame = geometry[plotFrameAnchor]
        let lastIndex = chartData.count - 1
        
        guard lastIndex >= 0,
              let xPos = proxy.position(forX: lastIndex),
              let yPos = proxy.position(forY: currentPriceValue),
              xPos.isFinite && !xPos.isNaN,
              yPos.isFinite && !yPos.isNaN else {
            return AnyView(EmptyView())
        }
        
        let x = plotFrame.minX + xPos
        let y = plotFrame.minY + yPos
        let lineWidth = max(0, plotFrame.width - (x - plotFrame.minX))
        
        return AnyView(
            ZStack {
                // Horizontal price line - TradingView style
                Rectangle()
                    .fill(Color(red: 0.77, green: 0.80, blue: 0.81, opacity: 0.5))
                    .frame(width: lineWidth, height: 0.5)
                    .position(x: (x + plotFrame.maxX) / 2, y: y)
                
                // Price label - TradingView style
                Text(formatPrice(currentPriceValue))
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.white)
                    .position(x: plotFrame.maxX - 45, y: y)
            }
            .animation(.linear(duration: 0.2), value: currentPriceValue)
        )
    }
    
    // MARK: - Time Axis
    private var timeAxis: some View {
        HStack(spacing: 0) {
            let timeLabels = getTimeLabels()
            ForEach(Array(timeLabels.enumerated()), id: \.offset) { index, label in
                Spacer()
                Text(label)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(Color(red: 0.13, green: 0.13, blue: 0.13))
                if index < timeLabels.count - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(height: 32)
        .background(Color.white)
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
    }
    
    // MARK: - Helper Functions
    private func formatPrice(_ value: Double) -> String {
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
