import SwiftUI

struct OnboardingPage3View: View {
    @State private var avatarStates: [Int: Bool] = [:]
    @State private var showHeadline = false
    @State private var showSubtext = false
    @State private var showProofBlock1 = false
    @State private var showProofBlock2 = false
    @State private var showProofBlock3 = false
    @State private var showMicroCopy = false
    @State private var showCTA = false
    
    // Avatar data with positions (loose cluster) and delays
    let avatars: [(id: Int, offsetX: CGFloat, offsetY: CGFloat, delay: Double)] = [
        (1, -15, -8, 0.0),
        (2, 12, -5, 0.1),
        (3, -8, 5, 0.15),
        (4, 18, 8, 0.25),
        (5, -20, 0, 0.35),
        (6, 8, -10, 0.45),
        (7, -12, 10, 0.55),
        (8, 15, 3, 0.65)
    ]
    
    // Avatars that show online indicators
    let onlineAvatars = [1, 3, 5, 7]
    
    var body: some View {
        ZStack {
            // Warm neutral background
            Color(red: 0.98, green: 0.97, blue: 0.96)
                .ignoresSafeArea()
            
            // Subtle grain texture overlay
            GrainTextureView()
                .opacity(0.03)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Avatar group - loose cluster arrangement
                ZStack {
                    ForEach(avatars, id: \.id) { avatar in
                        AvatarView(
                            id: avatar.id,
                            isOnline: onlineAvatars.contains(avatar.id),
                            isVisible: avatarStates[avatar.id] ?? false
                        )
                        .offset(x: avatar.offsetX, y: avatar.offsetY)
                        .opacity(avatarStates[avatar.id] ?? false ? 1 : 0)
                        .offset(
                            x: (avatarStates[avatar.id] ?? false) ? 0 : avatar.offsetX * 1.2,
                            y: (avatarStates[avatar.id] ?? false) ? 0 : avatar.offsetY * 0.5
                        )
                    }
                }
                .frame(width: 200, height: 140)
                .padding(.bottom, 60)
                
                // Headline
                Text("You're not learning alone.")
                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .opacity(showHeadline ? 1 : 0)
                    .offset(y: showHeadline ? 0 : 10)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                
                // Subtext
                Text("Investing101 is a community of people who chose to stop guessing —\nand start understanding.")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .opacity(showSubtext ? 0.85 : 0)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                
                // Proof blocks
                VStack(spacing: 16) {
                    ProofBlockView(text: "Built for beginners. Trusted by learners.", show: showProofBlock1)
                    ProofBlockView(text: "No hype. No fake gurus. No pressure.", show: showProofBlock2)
                    ProofBlockView(text: "Learn → Practice → Improve.", show: showProofBlock3)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                // Micro-copy
                Text("Everyone here started exactly where you are.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(showMicroCopy ? 0.6 : 0)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                
                // CTA Button
                Button(action: {
                    // Handle join action
                }) {
                    Text("Join the community")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                                .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        )
                }
                .scaleEffect(showCTA ? 1.0 : 0.96)
                .opacity(showCTA ? 1 : 0)
                .padding(.horizontal, 32)
                .padding(.bottom, 60)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Avatars fade + slide in individually with delays
        for avatar in avatars {
            DispatchQueue.main.asyncAfter(deadline: .now() + avatar.delay) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatarStates[avatar.id] = true
                }
            }
        }
        
        // Headline - appears after first avatar starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.6)) {
                showHeadline = true
            }
        }
        
        // Subtext - gentle reveal
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                showSubtext = true
            }
        }
        
        // Proof blocks cascade - start after subtext
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) {
                showProofBlock1 = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.4)) {
                showProofBlock2 = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeOut(duration: 0.4)) {
                showProofBlock3 = true
            }
        }
        
        // Micro-copy - appears last, quiet reassurance
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut(duration: 0.5)) {
                showMicroCopy = true
            }
        }
        
        // CTA - invitation, not pressure
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            withAnimation(.easeOut(duration: 0.45)) {
                showCTA = true
            }
        }
    }
}

// MARK: - Avatar View
struct AvatarView: View {
    let id: Int
    let isOnline: Bool
    let isVisible: Bool
    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.6
    
    // Diverse avatar colors (representing different people)
    private var avatarColor: Color {
        let colors: [Color] = [
            Color(red: 0.4, green: 0.3, blue: 0.25),   // Brown
            Color(red: 0.25, green: 0.2, blue: 0.15),  // Dark brown
            Color(red: 0.5, green: 0.4, blue: 0.35),   // Medium brown
            Color(red: 0.35, green: 0.28, blue: 0.22), // Brown
            Color(red: 0.45, green: 0.35, blue: 0.3),  // Brown
            Color(red: 0.3, green: 0.25, blue: 0.2),   // Dark brown
            Color(red: 0.42, green: 0.32, blue: 0.27), // Brown
            Color(red: 0.38, green: 0.3, blue: 0.24)   // Brown
        ]
        return colors[(id - 1) % colors.count]
    }
    
    var body: some View {
        ZStack {
            // Avatar circle
            Circle()
                .fill(avatarColor)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
            
            // Online indicator
            if isOnline {
                Circle()
                    .fill(Color(red: 0.2, green: 0.7, blue: 0.4)) // Soft green
                    .frame(width: 12, height: 12)
                    .offset(x: 18, y: 18)
                    .scaleEffect(pulseScale)
                    .opacity(pulseOpacity)
            }
        }
        .onChange(of: isVisible) { oldValue, newValue in
            if newValue && isOnline {
                startPulseAnimation()
            }
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(
            Animation
                .easeInOut(duration: 2.75)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.15
            pulseOpacity = 1.0
        }
    }
}

// MARK: - Proof Block View
struct ProofBlockView: View {
    let text: String
    let show: Bool
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 8)
    }
}

// MARK: - Grain Texture View
struct GrainTextureView: View {
    // Static seed for consistent grain pattern
    private static let seed: UInt64 = 12345
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                // Create very subtle static noise texture (2-4% opacity overall)
                var generator = SeededRandomGenerator(seed: Self.seed)
                let pointCount = Int(size.width * size.height * 0.005)
                
                for _ in 0..<pointCount {
                    let x = generator.next(in: 0..<size.width)
                    let y = generator.next(in: 0..<size.height)
                    let alpha = generator.next(in: 0.02..<0.04)
                    
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: y, width: 1, height: 1)),
                        with: .color(.black.opacity(alpha))
                    )
                }
            }
        }
    }
}

// MARK: - Seeded Random Generator
struct SeededRandomGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed
    }
    
    mutating func next(in range: Range<Double>) -> Double {
        state = state &* 1103515245 &+ 12345
        let normalized = Double(state & 0x7FFFFFFF) / Double(0x7FFFFFFF)
        return range.lowerBound + normalized * (range.upperBound - range.lowerBound)
    }
}

