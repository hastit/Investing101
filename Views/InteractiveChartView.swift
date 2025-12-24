import SwiftUI
import Charts

struct InteractiveChartView: View {
    let stock: Stock
    @State private var zoomLevel: Double = 1.0
    @State private var panOffset: Double = 0.0
    @State private var isZooming = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Chart
            GeometryReader { geometry in
                Chart {
                    ForEach(Array(chartData.enumerated()), id: \.offset) { index, value in
                        LineMark(
                            x: .value("Time", index),
                            y: .value("Price", value)
                        )
                        .foregroundStyle(Color(hex: stock.color) ?? .blue)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .interpolationMethod(.catmullRom)
                        
                        AreaMark(
                            x: .value("Time", index),
                            y: .value("Price", value)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    (Color(hex: stock.color) ?? .blue).opacity(0.4),
                                    (Color(hex: stock.color) ?? .blue).opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartXScale(domain: chartXRange)
                .chartYScale(domain: chartYRange)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 8)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: .automatic(desiredCount: 6)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
                .gesture(
                    SimultaneousGesture(
                        MagnificationGesture()
                            .onChanged { scale in
                                if scale != 1.0 {
                                    isZooming = true
                                    let newZoom = zoomLevel * scale
                                    zoomLevel = min(max(newZoom, 0.5), 5.0)
                                }
                            }
                            .onEnded { _ in
                                isZooming = false
                            },
                        DragGesture()
                            .onChanged { value in
                                if !isZooming {
                                    let dragAmount = value.translation.width / 20.0
                                    panOffset += dragAmount
                                    // Constrain pan
                                    let maxOffset = Double(stock.chartData.count) * (zoomLevel - 1.0) * 0.5
                                    panOffset = min(max(panOffset, -maxOffset), maxOffset)
                                }
                            }
                    )
                )
            }
            .frame(height: 350)
            
            // Zoom controls
            HStack(spacing: 20) {
                Button(action: { withAnimation { zoomLevel = min(zoomLevel + 0.5, 5.0) } }) {
                    Image(systemName: "plus.magnifyingglass")
                        .font(.title2)
                }
                .disabled(zoomLevel >= 5.0)
                
                Text("Zoom: \(Int(zoomLevel * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(minWidth: 100)
                
                Button(action: { withAnimation { zoomLevel = max(zoomLevel - 0.5, 0.5) } }) {
                    Image(systemName: "minus.magnifyingglass")
                        .font(.title2)
                }
                .disabled(zoomLevel <= 0.5)
                
                Spacer()
                
                Button(action: { 
                    withAnimation {
                        zoomLevel = 1.0
                        panOffset = 0.0
                    }
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .padding()
    }
    
    // Computed chart ranges based on zoom and pan
    private var chartData: [Double] {
        stock.chartData
    }
    
    private var chartXRange: ClosedRange<Double> {
        let totalPoints = Double(stock.chartData.count)
        let visiblePoints = totalPoints / zoomLevel
        let start = max(0.0, panOffset)
        let end = min(totalPoints, start + visiblePoints)
        return start...end
    }
    
    private var chartYRange: ClosedRange<Double> {
        let allValues = stock.chartData
        guard !allValues.isEmpty else { return 0...100 }
        
        let minValue = allValues.min() ?? 0
        let maxValue = allValues.max() ?? 100
        let range = maxValue - minValue
        let padding = range * 0.1 // 10% padding
        
        return (minValue - padding)...(maxValue + padding)
    }
}



