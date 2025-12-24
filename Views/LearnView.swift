import SwiftUI

struct LearnView: View {
    @StateObject private var learningManager = LearningManager()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Progress overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Progress")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ProgressView(value: learningManager.overallProgress)
                            .tint(.blue)
                        
                        Text("\(Int(learningManager.overallProgress * 100))% Complete")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    Text("Learning Path")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Learning modules
                    ForEach(learningManager.modules) { module in
                        LearningModuleCard(module: module, learningManager: learningManager)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Learn")
        }
    }
}

struct LearningModuleCard: View {
    let module: LearningModule
    @ObservedObject var learningManager: LearningManager
    @State private var showLessons = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: module.icon)
                    .font(.title)
                    .foregroundColor(module.isCompleted ? .green : .blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(module.title)
                        .font(.headline)
                    
                    Text("\(module.completedLessons)/\(module.totalLessons) lessons")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if module.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            ProgressView(value: module.progress)
                .tint(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .onTapGesture {
            showLessons = true
        }
        .sheet(isPresented: $showLessons) {
            LessonsListView(module: module, learningManager: learningManager)
        }
    }
}

struct LessonsListView: View {
    let module: LearningModule
    @ObservedObject var learningManager: LearningManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(module.lessons) { lesson in
                    LessonRowView(lesson: lesson, module: module, learningManager: learningManager)
                }
            }
            .navigationTitle(module.title)
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

struct LessonRowView: View {
    let lesson: Lesson
    let module: LearningModule
    @ObservedObject var learningManager: LearningManager
    
    var body: some View {
        HStack {
            // Icon
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: 44, height: 44)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lesson.title)
                    .font(.headline)
                
                if let subtitle = lesson.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if lesson.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            showLesson()
        }
    }
    
    private var backgroundColor: Color {
        if lesson.isCompleted {
            return .green.opacity(0.1)
        } else if lesson.isLocked {
            return .gray.opacity(0.1)
        } else {
            return .blue.opacity(0.1)
        }
    }
    
    private var iconColor: Color {
        if lesson.isCompleted {
            return .green
        } else if lesson.isLocked {
            return .gray
        } else {
            return .blue
        }
    }
    
    private var icon: String {
        if lesson.isCompleted {
            return "checkmark.circle"
        } else if lesson.isLocked {
            return "lock.circle"
        } else {
            return lesson.icon ?? "doc.text"
        }
    }
    
    private func showLesson() {
        // In a real app, you'd navigate to the lesson content
        if !lesson.isLocked && !lesson.isCompleted {
            learningManager.completeLesson(lessonId: lesson.id, inModule: module.id)
        }
    }
}

// MARK: - Models and Data

class LearningManager: ObservableObject {
    @Published var modules: [LearningModule] = []
    
    var overallProgress: Double {
        guard !modules.isEmpty else { return 0 }
        let totalLessons = modules.reduce(0) { $0 + $1.totalLessons }
        let completedLessons = modules.reduce(0) { $0 + $1.completedLessons }
        return Double(completedLessons) / Double(totalLessons)
    }
    
    init() {
        loadModules()
    }
    
    private func loadModules() {
        modules = [
            LearningModule(
                id: "basics",
                title: "Investment Basics",
                icon: "book.fill",
                lessons: [
                    Lesson(id: "1", title: "What is Investing?", subtitle: "Introduction", icon: "questionmark.circle"),
                    Lesson(id: "2", title: "Types of Investments", subtitle: "Stocks, Bonds, ETFs", icon: "chart.pie"),
                    Lesson(id: "3", title: "Risk vs Reward", subtitle: "Understanding risk", icon: "exclamationmark.triangle"),
                    Lesson(id: "4", title: "Building a Portfolio", subtitle: "Diversification", icon: "square.grid.2x2")
                ]
            ),
            LearningModule(
                id: "stocks",
                title: "Stock Market",
                icon: "chart.line.uptrend.xyaxis",
                lessons: [
                    Lesson(id: "5", title: "How Stocks Work", subtitle: "Company ownership", icon: "building.2"),
                    Lesson(id: "6", title: "Reading Stock Charts", subtitle: "Price movements", icon: "chart.xyaxis.line"),
                    Lesson(id: "7", title: "Buying vs Selling", subtitle: "Market orders", icon: "arrow.triangle.2.circlepath"),
                    Lesson(id: "8", title: "Market Timing", subtitle: "When to trade", icon: "clock")
                ]
            ),
            LearningModule(
                id: "crypto",
                title: "Cryptocurrency",
                icon: "bitcoinsign.circle.fill",
                lessons: [
                    Lesson(id: "9", title: "Understanding Bitcoin", subtitle: "Digital currency", icon: "network"),
                    Lesson(id: "10", title: "Blockchain Basics", subtitle: "How it works", icon: "link"),
                    Lesson(id: "11", title: "Crypto Volatility", subtitle: "High risk", icon: "chart.line.uptrend.xyaxis")
                ]
            ),
            LearningModule(
                id: "commodities",
                title: "Commodities",
                icon: "leaf.fill",
                lessons: [
                    Lesson(id: "12", title: "Gold as Investment", subtitle: "Precious metals", icon: "star.fill"),
                    Lesson(id: "13", title: "Oil Trading", subtitle: "Energy commodities", icon: "drop.fill"),
                    Lesson(id: "14", title: "Commodity Futures", subtitle: "Futures contracts", icon: "calendar")
                ]
            )
        ]
    }
    
    func completeLesson(lessonId: String, inModule moduleId: String) {
        if let moduleIndex = modules.firstIndex(where: { $0.id == moduleId }) {
            if let lessonIndex = modules[moduleIndex].lessons.firstIndex(where: { $0.id == lessonId }) {
                modules[moduleIndex].lessons[lessonIndex].isCompleted = true
                modules[moduleIndex].updateProgress()
            }
        }
    }
}

struct LearningModule: Identifiable {
    let id: String
    let title: String
    let icon: String
    var lessons: [Lesson]
    
    var completedLessons: Int {
        lessons.filter { $0.isCompleted }.count
    }
    
    var totalLessons: Int {
        lessons.count
    }
    
    var progress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons) / Double(totalLessons)
    }
    
    var isCompleted: Bool {
        completedLessons == totalLessons
    }
    
    mutating func updateProgress() {
        // Progress is computed property
    }
}

struct Lesson: Identifiable {
    let id: String
    let title: String
    var subtitle: String?
    let icon: String?
    var isCompleted: Bool = false
    var isLocked: Bool = false
}

