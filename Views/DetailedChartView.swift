import SwiftUI
import Charts

struct DetailedChartView: View {
    let stock: Stock
    @Environment(\.dismiss) var dismiss
    @State private var zoomLevel: Double = 1.0
    @State private var panOffset: Double = 0.0
    @State private var selectedTimeframe = "1D"
    @State private var yAxisZoom: Double = 1.0
    @State private var lastPanOffset: Double = 0
    
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
            
            // Chart
            GeometryReader { geometry in
                Chart {
                    ForEach(visibleData, id: \.index) { dataPoint in
                        LineMark(
                            x: .value("Time", dataPoint.index),
                            y: .value("Price", dataPoint.value)
                        )
                        .foregroundStyle(Color(hex: stock.color) ?? .blue)
                        .lineStyle(StrokeStyle(lineWidth: 2.0, lineCap: .round))
                        .interpolationMethod(.linear)
                    }
                }
                .chartYScale(domain: yAxisRange)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 6)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(.systemGray3))
                        AxisValueLabel()
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing, values: .automatic(desiredCount: 8)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color(.systemGray3))
                        AxisValueLabel {
                            if let value = value.as(Double.self) {
                                Text(formatPrice(value))
                            }
                        }
                        .font(.caption)
                        .fontWeight(.medium)
                    }
                }
                .gesture(makeDragGesture())
                .gesture(makeMagnificationGesture())
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
            
            // Zoom Controls
            VStack(spacing: 8) {
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("X-Axis")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 12) {
                            Button(action: { 
                                withAnimation { zoomLevel = min(zoomLevel + 0.2, 3.0) }
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(zoomLevel >= 3.0 ? .gray : .blue)
                            }
                            .disabled(zoomLevel >= 3.0)
                            
                            Text("\(Int(zoomLevel * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(minWidth: 50)
                            
                            Button(action: { 
                                withAnimation { zoomLevel = max(zoomLevel - 0.2, 0.5) }
                            }) {
                                Image(systemName: "plus")
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
                                withAnimation { yAxisZoom = min(yAxisZoom + 0.2, 5.0) }
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(yAxisZoom >= 5.0 ? .gray : .blue)
                            }
                            .disabled(yAxisZoom >= 5.0)
                            
                            Text("\(Int(yAxisZoom * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .frame(minWidth: 50)
                            
                            Button(action: { 
                                withAnimation { yAxisZoom = max(yAxisZoom - 0.2, 0.3) }
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(yAxisZoom <= 0.3 ? .gray : .blue)
                            }
                            .disabled(yAxisZoom <= 0.3)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { 
                        withAnimation {
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
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Text("Horizontal drag: Pan | Vertical drag: Zoom Y | Pinch: Zoom X")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .background(Color(.systemGray6))
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
    
    private var yAxisRange: ClosedRange<Double> {
        let data = stock.chartData
        guard !data.isEmpty else { return 0...100 }
        
        let minValue = data.min() ?? 0
        let maxValue = data.max() ?? 100
        let range = maxValue - minValue
        let padding = range * 0.1
        
        let center = (minValue + maxValue) / 2
        let newRange = (range + padding * 2) / yAxisZoom
        
        return (center - newRange / 2)...(center + newRange / 2)
    }
    
    private func makeDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = value.translation.width
                let dragSensitivity = 6.0  // Slower panning
                
                let maxOffset = Double(stock.chartData.count) * (zoomLevel - 1.0) * 0.5
                let newOffset = panOffset - (Double(delta) / dragSensitivity)
                panOffset = min(max(newOffset, -maxOffset), maxOffset)
            }
    }
    
    private func makeMagnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged { scale in
                let baseScale: Double = 1.0
                let newZoom = zoomLevel * (Double(scale) / baseScale)
                zoomLevel = min(max(newZoom, 0.5), 3.0)
            }
    }
    
    private func getPriceChange() -> Double {
        let data = stock.chartData
        guard data.count >= 2 else { return 0 }
        let current = data.last ?? 0
        let previous = data[data.count - 2]
        return ((current - previous) / previous) * 100
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
}



