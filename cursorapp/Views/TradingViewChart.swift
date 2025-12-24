import SwiftUI
import Charts

struct TradingViewChartView: View {
    let stock: Stock
    @Environment(\.dismiss) var dismiss
    @State private var timeZoom: Double = 1.0
    @State private var priceZoom: Double = 1.0
    @State private var panOffset: Double = 0
    @State private var priceCenter: Double = 0
    @State private var isDraggingX: Bool = false
    @State private var isDraggingY: Bool = false
    @State private var hoverLocation: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Header Bar
            headerBar
            
            Divider()
            
            // Chart Area with Crosshair
            GeometryReader { geometry in
                ZStack {
                    // Main Chart
                    Chart {
                        ForEach(chartData, id: \.time) { point in
                            LineMark(
                                x: .value("Time", point.time),
                                y: .value("Price", point.price)
                            )
                            .foregroundStyle(Color(hex: stock.color) ?? .blue)
                            .lineStyle(StrokeStyle(lineWidth: 1.5, lineCap: .square))
                            .interpolationMethod(.linear)
                        }
                    }
                    .chartXScale(domain: timeDomain)
                    .chartYScale(domain: priceDomain)
                    .chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 8)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                .foregroundStyle(Color(hex: "2B2B43"))
                            AxisValueLabel()
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(Color(hex: "787B86"))
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .trailing, values: .automatic(desiredCount: 10)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                                .foregroundStyle(Color(hex: "2B2B43"))
                            AxisValueLabel {
                                if let price = value.as(Double.self) {
                                    Text(formatPrice(price))
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundStyle(Color(hex: "787B86"))
                                }
                            }
                        }
                    }
                    .chartPlotStyle { plotArea in
                        plotArea
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black)
                    }
                    
                    // Crosshair and Zoom Indicators
                    if isDraggingX || isDraggingY {
                        crosshairView
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            handleDrag(value, in: geometry)
                        }
                        .onEnded { _ in
                            isDraggingX = false
                            isDraggingY = false
                        }
                )
                .gesture(magnificationGesture)
                .contentShape(Rectangle())
            }
            
            // Bottom Control Bar
            controlBar
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(stock.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                
                Text(stock.symbol)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "787B86"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatPrice(stock.chartData.last ?? 0))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                let change = getPriceChange()
                Text(change >= 0 ? "+\(String(format: "%.2f", change))%" : "\(String(format: "%.2f", change))%")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(change >= 0 ? Color(hex: "089981") : Color(hex: "F23645"))
            }
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "787B86"))
                    .frame(width: 32, height: 32)
                    .background(Color(hex: "2B2B43"))
                    .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "1E222D"))
    }
    
    // MARK: - Control Bar
    private var controlBar: some View {
        HStack(spacing: 20) {
            // Time Scale Controls
            VStack(spacing: 4) {
                Text("TIME")
                    .font(.caption2)
                    .foregroundStyle(Color(hex: "787B86"))
                
                HStack(spacing: 8) {
                    Button(action: { withAnimation { timeZoom = min(timeZoom + 0.25, 5.0) } }) {
                        Text("+")
                            .font(.caption)
                            .frame(width: 24, height: 24)
                            .background(Color(hex: "2B2B43"))
                            .foregroundStyle(timeZoom >= 5.0 ? .gray : .white)
                    }
                    .disabled(timeZoom >= 5.0)
                    
                    Text("\(Int(timeZoom * 100))%")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .frame(minWidth: 45)
                    
                    Button(action: { withAnimation { timeZoom = max(timeZoom - 0.25, 0.25) } }) {
                        Text("−")
                            .font(.caption)
                            .frame(width: 24, height: 24)
                            .background(Color(hex: "2B2B43"))
                            .foregroundStyle(timeZoom <= 0.25 ? .gray : .white)
                    }
                    .disabled(timeZoom <= 0.25)
                }
            }
            
            Divider()
                .frame(height: 40)
                .foregroundStyle(Color(hex: "2B2B43"))
            
            // Price Scale Controls
            VStack(spacing: 4) {
                Text("PRICE")
                    .font(.caption2)
                    .foregroundStyle(Color(hex: "787B86"))
                
                HStack(spacing: 8) {
                    Button(action: { withAnimation { priceZoom = min(priceZoom + 0.25, 5.0) } }) {
                        Text("+")
                            .font(.caption)
                            .frame(width: 24, height: 24)
                            .background(Color(hex: "2B2B43"))
                            .foregroundStyle(priceZoom >= 5.0 ? .gray : .white)
                    }
                    .disabled(priceZoom >= 5.0)
                    
                    Text("\(Int(priceZoom * 100))%")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .frame(minWidth: 45)
                    
                    Button(action: { withAnimation { priceZoom = max(priceZoom - 0.25, 0.25) } }) {
                        Text("−")
                            .font(.caption)
                            .frame(width: 24, height: 24)
                            .background(Color(hex: "2B2B43"))
                            .foregroundStyle(priceZoom <= 0.25 ? .gray : .white)
                    }
                    .disabled(priceZoom <= 0.25)
                }
            }
            
            Spacer()
            
            // Reset Button
            Button(action: resetView) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset")
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(hex: "2962FF"))
                .cornerRadius(4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "1E222D"))
    }
    
    // MARK: - Crosshair View
    private var crosshairView: some View {
        Group {
            // Horizontal line (following Y axis)
            if isDraggingY {
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                    .overlay(
                        HStack {
                            Spacer()
                            Triangle()
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                        }
                    )
            }
            
            // Vertical line (following X axis)
            if isDraggingX {
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 1)
                    .overlay(
                        VStack {
                            Triangle()
                                .rotation(.degrees(90))
                                .fill(Color.white)
                                .frame(width: 8, height: 8)
                            Spacer()
                        }
                    )
            }
        }
    }
    
    // MARK: - Computed Properties
    private var chartData: [(time: Int, price: Double)] {
        stock.chartData.enumerated().map { (index, value) in
            (time: index, price: value)
        }
    }
    
    private var timeDomain: ClosedRange<Int> {
        let totalPoints = stock.chartData.count
        let visiblePoints = Int(Double(totalPoints) / timeZoom)
        let start = max(0, Int(panOffset))
        let end = min(totalPoints, start + visiblePoints)
        return start...end
    }
    
    private var priceDomain: ClosedRange<Double> {
        let data = stock.chartData
        guard !data.isEmpty else { return 0...100 }
        
        let minPrice = data.min() ?? 0
        let maxPrice = data.max() ?? 100
        let center = priceCenter == 0 ? (minPrice + maxPrice) / 2 : priceCenter
        let range = (maxPrice - minPrice) / priceZoom
        
        return (center - range / 2)...(center + range / 2)
    }
    
    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                timeZoom = min(max(timeZoom * Double(scale), 0.25), 5.0)
            }
    }
    
    // MARK: - Methods
    private func handleDrag(_ value: DragGesture.Value, in geometry: GeometryProxy) {
        let location = value.location
        let width = geometry.size.width
        let height = geometry.size.height
        
        // Detect which axis we're dragging
        let margin = 50.0
        
        if location.x < margin {
            // Dragging Y-axis (left side)
            isDraggingY = true
            let heightRatio = location.y / height
            let currentRange = priceDomain.upperBound - priceDomain.lowerBound
            priceCenter = priceDomain.lowerBound + (currentRange * heightRatio)
        } else if location.y > height - margin {
            // Dragging X-axis (bottom)
            isDraggingX = true
            let widthRatio = location.x / width
            let visiblePoints = Double(stock.chartData.count) / timeZoom
            let maxOffset = Double(stock.chartData.count) - visiblePoints
            panOffset = maxOffset * Double(widthRatio)
        }
    }
    
    private func resetView() {
        withAnimation(.easeInOut(duration: 0.3)) {
            timeZoom = 1.0
            priceZoom = 1.0
            panOffset = 0
            priceCenter = 0
        }
    }
    
    private func formatPrice(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "$%.0f", value)
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

// MARK: - Triangle Shape for Zoom Indicators
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



