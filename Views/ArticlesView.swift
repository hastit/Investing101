import SwiftUI

struct ArticlesView: View {
    @StateObject private var articlesManager = ArticlesManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(articlesManager.articles) { article in
                        ArticleCard(article: article)
                    }
                }
                .padding()
            }
            .navigationTitle("Articles")
        }
    }
}

struct ArticleCard: View {
    let article: Article
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Featured image
            if let color = article.color {
                Rectangle()
                    .fill(Color(hex: color) ?? .blue)
                    .frame(height: 180)
                    .cornerRadius(12)
            }
            
            // Category
            Text(article.category.uppercased())
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(article.categoryColor)
            
            // Title
            Text(article.title)
                .font(.title3)
                .fontWeight(.bold)
            
            // Excerpt
            if let excerpt = article.excerpt {
                Text(excerpt)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            // Meta
            HStack {
                if let author = article.author {
                    Text(author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let readTime = article.readTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(readTime)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .onTapGesture {
            showDetails = true
        }
        .sheet(isPresented: $showDetails) {
            ArticleDetailView(article: article)
        }
    }
}

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Image
                    if let color = article.color {
                        Rectangle()
                            .fill(Color(hex: color) ?? .blue)
                            .frame(height: 250)
                    }
                    
                    // Category
                    Text(article.category.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(article.categoryColor)
                    
                    // Title
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Meta
                    HStack {
                        if let author = article.author {
                            Text(author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if let readTime = article.readTime {
                            Text("· \(readTime)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(article.content, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(article.title)
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

// MARK: - Models and Data

class ArticlesManager: ObservableObject {
    @Published var articles: [Article] = []
    
    init() {
        loadArticles()
    }
    
    private func loadArticles() {
        articles = [
            Article(
                title: "Dollar-Cost Averaging: A Beginner's Strategy",
                excerpt: "Learn how investing a fixed amount regularly can reduce the impact of market volatility and build wealth over time.",
                category: "Strategy",
                author: "Investment Team",
                readTime: "5 min read",
                color: "4A90E2",
                content: [
                    "Dollar-cost averaging (DCA) is an investment strategy where you invest a fixed amount of money at regular intervals, regardless of the asset's price. This approach helps investors avoid the stress of trying to time the market and instead focus on consistent investing.",
                    "One of the key benefits of dollar-cost averaging is that it reduces the impact of market volatility on your investments. When prices are high, your fixed investment buys fewer shares. When prices are low, your investment buys more shares. Over time, this can result in a lower average cost per share.",
                    "For example, if you invest $100 every month in a stock, you'll buy more shares when the price is $50 and fewer shares when the price is $100. This automatic rebalancing is one of the reasons why DCA is so effective for long-term wealth building.",
                    "While dollar-cost averaging doesn't guarantee profits or protect against losses, it's a proven strategy used by millions of investors worldwide. It's particularly useful for beginner investors who are just starting their investment journey."
                ]
            ),
            Article(
                title: "Understanding Market Volatility",
                excerpt: "Market volatility can be intimidating, but understanding it is key to becoming a successful investor.",
                category: "Education",
                author: "Market Experts",
                readTime: "6 min read",
                color: "F5A623",
                content: [
                    "Market volatility refers to the degree of variation in trading prices over time. It's measured using statistical tools like standard deviation and variance. A highly volatile market means prices fluctuate rapidly and unpredictably.",
                    "There are several factors that contribute to market volatility, including economic indicators, company earnings reports, geopolitical events, and investor sentiment. Understanding these factors can help you make more informed investment decisions.",
                    "It's important to remember that volatility is a normal part of market behavior. Markets go up and down regularly, and this fluctuation is actually necessary for the markets to function properly. Volatility creates opportunities for both gains and losses.",
                    "For long-term investors, volatility is often seen as an opportunity rather than a risk. When markets drop, it can be a good time to buy quality assets at discounted prices. This is why many successful investors remain invested during market downturns."
                ]
            ),
            Article(
                title: "The Power of Compound Interest",
                excerpt: "Compound interest is often called the eighth wonder of the world - and for good reason.",
                category: "Basics",
                author: "Finance Educators",
                readTime: "4 min read",
                color: "7ED321",
                content: [
                    "Compound interest is the concept of earning interest on your interest, which creates exponential growth over time. It's one of the most powerful forces in investing and wealth building.",
                    "Here's how it works: when you invest money, you earn returns. Those returns are then reinvested, and you start earning returns on those returns. This compounding effect accelerates your wealth accumulation over time.",
                    "For example, if you invest $1,000 at a 10% annual return, after one year you have $1,100. In year two, you earn 10% on $1,100, giving you $1,210. After 30 years at 10% annual returns, that initial $1,000 becomes over $17,000 - without adding any additional money!",
                    "The key to maximizing compound interest is to start early and stay invested for the long term. Even starting a few years earlier can make a significant difference in your final wealth due to the compounding effect."
                ]
            ),
            Article(
                title: "Diversification: Don't Put All Eggs in One Basket",
                excerpt: "Learn why spreading your investments across different assets is crucial for managing risk.",
                category: "Strategy",
                author: "Portfolio Advisors",
                readTime: "7 min read",
                color: "9013FE",
                content: [
                    "Diversification is a risk management strategy that involves spreading your investments across different types of assets, industries, and geographic regions. The goal is to reduce the impact of any single investment's poor performance on your overall portfolio.",
                    "A well-diversified portfolio includes a mix of stocks, bonds, commodities (like gold and oil), and other asset classes. Within stocks, it's also important to diversify across different sectors - technology, healthcare, finance, energy, etc.",
                    "The principle behind diversification is that different assets react differently to economic conditions. When one asset class is performing poorly, another might be performing well, helping to balance out your overall returns.",
                    "However, it's important to note that over-diversification can also be a problem. Holding too many positions can make it difficult to track your investments and may lead to merely average returns. The key is finding the right balance between diversification and portfolio simplicity."
                ]
            ),
            Article(
                title: "Reading Stock Charts Like a Pro",
                excerpt: "Master the basics of technical analysis and understand what stock charts are telling you.",
                category: "Technical Analysis",
                author: "Trading Experts",
                readTime: "8 min read",
                color: "D0021B",
                content: [
                    "Stock charts are visual representations of a stock's price movements over time. Learning to read these charts is an essential skill for any investor or trader. Charts help you identify trends, patterns, and potential trading opportunities.",
                    "The most basic chart shows price over time on a line. But there's much more information available in different chart types. Candlestick charts, for example, show the opening, closing, high, and low prices for each period, giving you more detail about price action.",
                    "Key elements to look for in charts include trends (upward, downward, or sideways), support and resistance levels, and trading volume. An upward trend with increasing volume is often a bullish signal, while a downward trend with high volume might indicate selling pressure.",
                    "While charts can be helpful, it's important to use them in conjunction with fundamental analysis (analyzing company financials and business prospects). Technical analysis works best when combined with a comprehensive understanding of the company and its industry."
                ]
            ),
            Article(
                title: "Understanding Cryptocurrency Markets",
                excerpt: "Navigate the world of Bitcoin, Ethereum, and other digital assets with confidence.",
                category: "Cryptocurrency",
                author: "Crypto Specialists",
                readTime: "10 min read",
                color: "F7931A",
                content: [
                    "Cryptocurrency represents a new asset class that has grown dramatically in popularity and market capitalization over the past decade. Unlike traditional currencies, cryptocurrencies are decentralized and operate on blockchain technology.",
                    "Bitcoin, the first and largest cryptocurrency, was created in 2009 as a peer-to-peer electronic cash system. Since then, thousands of other cryptocurrencies (often called altcoins) have been created, each with different features and use cases.",
                    "Investing in cryptocurrency comes with unique risks. The markets are highly volatile, with prices that can swing dramatically in short periods. They're also largely unregulated compared to traditional securities markets, which means less investor protection.",
                    "If you're considering cryptocurrency as part of your investment strategy, it's important to understand what you're investing in, only invest what you can afford to lose, and be prepared for high volatility. Many financial advisors recommend keeping cryptocurrency to a small percentage (1-5%) of your total portfolio."
                ]
            )
        ]
    }
}

struct Article: Identifiable {
    let id = UUID()
    let title: String
    var excerpt: String?
    let category: String
    var author: String?
    var readTime: String?
    let color: String?
    let content: [String]
    
    var categoryColor: Color {
        switch category.lowercased() {
        case "strategy": return .blue
        case "education": return .orange
        case "basics": return .green
        case "technical analysis": return .red
        case "cryptocurrency": return .orange
        default: return .gray
        }
    }
}

