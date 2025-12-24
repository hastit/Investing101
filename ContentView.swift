import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PortfolioView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Portfolio")
                }
                .tag(0)
            
            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
                .tag(1)
            
            ArticlesView()
                .tabItem {
                    Image(systemName: "doc.text.fill")
                    Text("Articles")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

