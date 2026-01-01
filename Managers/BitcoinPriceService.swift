import Foundation
import Combine

/// Service for fetching real-time Bitcoin prices from Binance WebSocket API
/// Uses public streams - no authentication required, App Store compliant
class BitcoinPriceService: ObservableObject {
    @Published var currentPrice: Double = 0.0
    @Published var priceHistory: [PriceDataPoint] = []
    @Published var isConnected: Bool = false
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()
    private let maxHistoryPoints = 100 // Keep last 100 data points for smooth chart
    
    // Binance WebSocket endpoint for BTCUSDT ticker stream
    private let binanceWSURL = URL(string: "wss://stream.binance.com:9443/ws/btcusdt@ticker")!
    
    struct PriceDataPoint: Identifiable {
        let id = UUID()
        let price: Double
        let timestamp: Date
    }
    
    struct BinanceTickerResponse: Codable {
        let c: String // Last price
        let E: Int64  // Event time
    }
    
    init() {
        // Initialize with a reasonable default (optional - can fetch from REST API first)
        currentPrice = 45000.0
    }
    
    func start() {
        guard webSocketTask == nil else { return }
        
        // Fetch initial price first for immediate display
        fetchInitialPrice()
        
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: binanceWSURL)
        webSocketTask?.resume()
        
        isConnected = true
        receiveMessage()
    }
    
    func stop() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.processMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.processMessage(text)
                    }
                @unknown default:
                    break
                }
                
                // Continue receiving messages
                if self.isConnected {
                    self.receiveMessage()
                }
                
            case .failure(let error):
                print("WebSocket error: \(error.localizedDescription)")
                // Attempt to reconnect after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    if self.isConnected {
                        self.start()
                    }
                }
            }
        }
    }
    
    private func processMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            let response = try JSONDecoder().decode(BinanceTickerResponse.self, from: data)
            
            if let price = Double(response.c) {
                DispatchQueue.main.async {
                    self.currentPrice = price
                    
                    // Add to history
                    let dataPoint = PriceDataPoint(
                        price: price,
                        timestamp: Date(timeIntervalSince1970: Double(response.E) / 1000.0)
                    )
                    
                    self.priceHistory.append(dataPoint)
                    
                    // Keep only last N points for performance
                    if self.priceHistory.count > self.maxHistoryPoints {
                        self.priceHistory.removeFirst()
                    }
                }
            }
        } catch {
            print("Error decoding Binance response: \(error)")
        }
    }
    
    /// Fetch initial price from Binance REST API for immediate display
    func fetchInitialPrice() {
        guard let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let priceString = json["price"] as? String,
                  let price = Double(priceString) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.currentPrice = price
                
                // Initialize history with current price
                if self?.priceHistory.isEmpty == true {
                    let dataPoint = PriceDataPoint(price: price, timestamp: Date())
                    self?.priceHistory = [dataPoint]
                }
            }
        }.resume()
    }
    
    /// Get chart data as array of Doubles for compatibility with existing chart code
    func getChartData() -> [Double] {
        if priceHistory.isEmpty {
            return [currentPrice] // Return at least current price
        }
        return priceHistory.map { $0.price }
    }
    
    deinit {
        stop()
    }
}
