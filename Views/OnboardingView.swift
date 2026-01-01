import SwiftUI

// MARK: - Models
struct InvestmentGoal: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct ExperienceLevel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct TimeCommitment: Identifiable {
    let id = UUID()
    let title: String
}

struct RiskMindset: Identifiable {
    let id = UUID()
    let title: String
}

struct OnboardingView: View {
    @Binding var isOnboardingComplete: Bool
    @AppStorage("userName") private var storedUserName: String = ""
    @State private var currentPage = 0
    @State private var userName: String = ""
    @State private var selectedGoal: InvestmentGoal?
    @State private var selectedExperience: ExperienceLevel?
    @State private var selectedTimeCommitment: TimeCommitment?
    @State private var selectedRiskMindset: RiskMindset?
    
    var body: some View {
        ZStack {
            // Root dark background - covers entire screen including safe areas
            Color(red: 0.05, green: 0.08, blue: 0.15)
                .ignoresSafeArea(.all)
            
            TabView(selection: $currentPage) {
                // HIGH-EMOTION FLOW PAGES
                OnboardingPage1WakeUp(currentPage: $currentPage)
                    .tag(0)
                    
                    OnboardingPage2FutureSelf(currentPage: $currentPage)
                        .tag(1)
                    
                    OnboardingPage3Community(currentPage: $currentPage)
                        .tag(2)
                    
                    OnboardingPage4Simulation(currentPage: $currentPage)
                        .tag(3)
                    
                    // PERSONALIZATION FLOW PAGES
                    OnboardingPage5Name(userName: $userName, currentPage: $currentPage)
                        .tag(4)
                    
                    OnboardingPage6Goal(selectedGoal: $selectedGoal, currentPage: $currentPage)
                        .tag(5)
                    
                    OnboardingPage7Experience(selectedExperience: $selectedExperience, currentPage: $currentPage)
                        .tag(6)
                    
                    OnboardingPage8Time(selectedTimeCommitment: $selectedTimeCommitment, currentPage: $currentPage)
                        .tag(7)
                    
                    OnboardingPage9Risk(selectedRiskMindset: $selectedRiskMindset, currentPage: $currentPage)
                        .tag(8)
                    
                    OnboardingPage10Commitment(
                        userName: userName,
                        selectedGoal: selectedGoal,
                        selectedExperience: selectedExperience,
                        selectedTimeCommitment: selectedTimeCommitment,
                        storedUserName: $storedUserName,
                        isOnboardingComplete: $isOnboardingComplete
                    )
                    .tag(9)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .background(Color.clear)
                .scrollContentBackground(.hidden)
        }
        .background(Color(red: 0.05, green: 0.08, blue: 0.15))
        .ignoresSafeArea(.all)
    }
}

// MARK: - PAGE 1: The Wake-Up Call
struct OnboardingPage1WakeUp: View {
    @Binding var currentPage: Int
    @State private var showContent = false
    @State private var lineOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Dark background with subtle animated gradient - full screen
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.15),
                    Color(red: 0.08, green: 0.12, blue: 0.20)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            // Subtle animated market line in background
            GeometryReader { geometry in
                Path { path in
                    let height = geometry.size.height
                    let midY = height * 0.5
                    
                    path.move(to: CGPoint(x: -50 + lineOffset, y: midY))
                    
                    for i in 0..<20 {
                        let x = CGFloat(i * 40) + lineOffset
                        let y = midY + sin(CGFloat(i) * 0.3) * 30
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.white.opacity(0.1), lineWidth: 2)
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Headline
                VStack(spacing: 20) {
                    Text("Most people never learn")
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("how money really works.")
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                // Subtext
                VStack(spacing: 12) {
                    Text("Not because they're not smart —")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("but because no one ever showed them.")
                        .font(.system(size: 18, weight: .regular, design: .default))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                
                // Supporting line
                Text("You decided to open this app. That already puts you ahead.")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // CTA
                Button(action: {
                    withAnimation {
                        currentPage = 1
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(showContent ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                showContent = true
            }
            
            // Animate market line
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                lineOffset = 200
            }
        }
    }
}

// MARK: - PAGE 2: The Future Self Visualization
struct OnboardingPage2FutureSelf: View {
    @Binding var currentPage: Int
    @State private var headlineOpacity: Double = 0
    @State private var headlineOffset: CGFloat = -30
    @State private var subtextOpacity: Double = 0
    @State private var subtextOffset: CGFloat = -22
    @State private var bullet1Opacity: Double = 0
    @State private var bullet1Offset: CGFloat = -16
    @State private var bullet2Opacity: Double = 0
    @State private var bullet2Offset: CGFloat = -16
    @State private var bullet3Opacity: Double = 0
    @State private var bullet3Offset: CGFloat = -16
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 14
    @State private var buttonScale: CGFloat = 0.98
    @State private var imageOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Light, warm, airy background
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.98, blue: 0.97),
                    Color(red: 0.98, green: 0.97, blue: 0.96),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            // Cinematic background image - blurred illustration with parallax
            ZStack {
                // Desk illustration (blurred representation)
                ZStack {
                    Image(systemName: "laptopcomputer")
                        .font(.system(size: 200))
                        .foregroundColor(.gray.opacity(0.15))
                        .offset(y: 40 + imageOffset)
                    
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 100))
                        .foregroundColor(.blue.opacity(0.2))
                        .offset(y: -20 + imageOffset)
                }
                .blur(radius: 12)
                
                // Dark overlay for text readability (5-8% opacity)
                Color.black.opacity(0.065)
                    .ignoresSafeArea(edges: .all)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Text content - left aligned
                VStack(alignment: .leading, spacing: 20) {
                    // Headline - Primary Thought
                    Text("Imagine understanding what others guess.")
                        .font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .opacity(headlineOpacity)
                        .offset(y: headlineOffset)
                    
                    // Subtext - Reframing Moment
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Markets. Risks. Timing.")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundColor(.gray)
                        
                        Text("Not as luck — but as logic.")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundColor(.gray)
                    }
                    .opacity(subtextOpacity)
                    .offset(y: subtextOffset)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                
                // Bullet Points - Sequential Settling
                VStack(alignment: .leading, spacing: 16) {
                    BulletPoint2(text: "You know why you invest.", opacity: bullet1Opacity, offset: bullet1Offset)
                    BulletPoint2(text: "You're not panicking when prices move.", opacity: bullet2Opacity, offset: bullet2Offset)
                    BulletPoint2(text: "You're playing the long game — confidently.", opacity: bullet3Opacity, offset: bullet3Offset)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                
                Spacer()
                
                // CTA Button - Affirmation Rise
                Button(action: {
                    withAnimation {
                        currentPage = 2
                    }
                }) {
                    Text("That's the version of me I want")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(buttonOpacity)
                .offset(y: buttonOffset)
                .scaleEffect(buttonScale)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .onAppear {
            // Background image parallax - slow vertical drift (20-30s, 5-10px)
            withAnimation(.easeInOut(duration: 25).repeatForever(autoreverses: true)) {
                imageOffset = 8
            }
            
            // Headline entrance - Primary Thought (0.9s, easeOut)
            withAnimation(.easeOut(duration: 0.9)) {
                headlineOpacity = 1.0
                headlineOffset = 0
            }
            
            // Subtext drop-in - Reframing Moment (delay 0.3s after headline, 0.7s duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.7)) {
                    subtextOpacity = 1.0
                    subtextOffset = 0
                }
            }
            
            // Bullet 1 - Sequential Settling (0.5s each, 0.25s delay between)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    bullet1Opacity = 1.0
                    bullet1Offset = 0
                }
            }
            
            // Bullet 2 (0.25s delay after bullet 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                withAnimation(.easeOut(duration: 0.5)) {
                    bullet2Opacity = 1.0
                    bullet2Offset = 0
                }
            }
            
            // Bullet 3 (0.25s delay after bullet 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    bullet3Opacity = 1.0
                    bullet3Offset = 0
                }
            }
            
            // CTA Button - Affirmation Rise (after all text, 0.45s, upward rise +14→0, scale 0.98→1.0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.45)) {
                    buttonOpacity = 1.0
                    buttonOffset = 0
                    buttonScale = 1.0
                }
            }
        }
    }
}

// BulletPoint component for page 2 - Sequential Settling with vertical offset
struct BulletPoint2: View {
    let text: String
    let opacity: Double
    let offset: CGFloat
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue)
                .frame(width: 6, height: 6)
                .offset(y: 8)
            
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
        .opacity(opacity)
        .offset(y: offset)
    }
}

struct BulletPoint: View {
    let text: String
    let show: Bool
    let delay: Double
    @State private var appeared = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue)
                .frame(width: 6, height: 6)
                .offset(y: 8)
            
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.5)) {
                    appeared = show
                }
            }
        }
    }
}

// MARK: - PAGE 3: Belonging & Community
struct OnboardingPage3Community: View {
    @Binding var currentPage: Int
    @State private var headlineOpacity: Double = 0
    @State private var headlineOffset: CGFloat = 10
    @State private var subtextOpacity: Double = 0
    @State private var proof1Opacity: Double = 0
    @State private var proof1Offset: CGFloat = 8
    @State private var proof2Opacity: Double = 0
    @State private var proof2Offset: CGFloat = 8
    @State private var proof3Opacity: Double = 0
    @State private var proof3Offset: CGFloat = 8
    @State private var microCopyOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.96
    
    // Avatar states - individual entrance animations
    @State private var avatar1Opacity: Double = 0
    @State private var avatar1Offset: CGFloat = -12
    @State private var avatar2Opacity: Double = 0
    @State private var avatar2Offset: CGFloat = 12
    @State private var avatar3Opacity: Double = 0
    @State private var avatar3Offset: CGFloat = -12
    @State private var avatar4Opacity: Double = 0
    @State private var avatar4Offset: CGFloat = 12
    @State private var avatar5Opacity: Double = 0
    @State private var avatar5Offset: CGFloat = -12
    
    var body: some View {
        ZStack {
            // Warm neutral background
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.98, blue: 0.97),
                    Color(red: 0.98, green: 0.97, blue: 0.96),
                    Color(red: 0.99, green: 0.99, blue: 0.98)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            // Subtle grain texture overlay (optional, 2-4% opacity)
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.black.opacity(0.02),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                Spacer()
                
                // Avatar Group - Human Arrival
                HStack(spacing: 16) {
                    AvatarWithIndicator(
                        opacity: avatar1Opacity,
                        offset: avatar1Offset,
                        gradientColors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                        showOnline: true
                    )
                    AvatarWithIndicator(
                        opacity: avatar2Opacity,
                        offset: avatar2Offset,
                        gradientColors: [Color.purple.opacity(0.6), Color.pink.opacity(0.6)],
                        showOnline: false
                    )
                    AvatarWithIndicator(
                        opacity: avatar3Opacity,
                        offset: avatar3Offset,
                        gradientColors: [Color.green.opacity(0.6), Color.blue.opacity(0.6)],
                        showOnline: true
                    )
                    AvatarWithIndicator(
                        opacity: avatar4Opacity,
                        offset: avatar4Offset,
                        gradientColors: [Color.orange.opacity(0.6), Color.red.opacity(0.6)],
                        showOnline: false
                    )
                    AvatarWithIndicator(
                        opacity: avatar5Opacity,
                        offset: avatar5Offset,
                        gradientColors: [Color.indigo.opacity(0.6), Color.blue.opacity(0.6)],
                        showOnline: true
                    )
                }
                .padding(.bottom, 50)
                
                // Headline - Centered & Grounded
                Text("You're not learning alone.")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .opacity(headlineOpacity)
                    .offset(y: headlineOffset)
                
                // Subtext - Gentle Reveal
                Text("Investing101 is a community of people who chose to stop guessing —\nand start understanding.")
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .opacity(subtextOpacity)
                
                // Community Proof Blocks - Soft Cascade
                VStack(alignment: .leading, spacing: 16) {
                    CommunityProof3(
                        text: "Built for beginners. Trusted by learners.",
                        opacity: proof1Opacity,
                        offset: proof1Offset
                    )
                    CommunityProof3(
                        text: "No hype. No fake gurus. No pressure.",
                        opacity: proof2Opacity,
                        offset: proof2Offset
                    )
                    CommunityProof3(
                        text: "Learn → Practice → Improve.",
                        opacity: proof3Opacity,
                        offset: proof3Offset
                    )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                // Micro-Copy - Emotional Anchor
                Text("Everyone here started exactly where you are.")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.bottom, 50)
                    .opacity(microCopyOpacity)
                
                Spacer()
                
                // CTA Button - Invitation, Not Pressure
                Button(action: {
                    withAnimation {
                        currentPage = 3
                    }
                }) {
                    Text("Join the community")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(buttonOpacity)
                .scaleEffect(buttonScale)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .onAppear {
            // Avatar 1 entrance (0.4s duration, 0.12s delay between)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatar1Opacity = 1.0
                    avatar1Offset = 0
                }
            }
            
            // Avatar 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatar2Opacity = 1.0
                    avatar2Offset = 0
                }
            }
            
            // Avatar 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatar3Opacity = 1.0
                    avatar3Offset = 0
                }
            }
            
            // Avatar 4
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatar4Opacity = 1.0
                    avatar4Offset = 0
                }
            }
            
            // Avatar 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.48) {
                withAnimation(.easeOut(duration: 0.4)) {
                    avatar5Opacity = 1.0
                    avatar5Offset = 0
                }
            }
            
            // Headline - Centered & Grounded (0.6s, upward rise +10→0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.6)) {
                    headlineOpacity = 1.0
                    headlineOffset = 0
                }
            }
            
            // Subtext - Gentle Reveal (delay 0.3s after headline, fade only, max opacity 0.85)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation(.easeOut(duration: 0.5)) {
                    subtextOpacity = 0.85
                }
            }
            
            // Proof Block 1 - Soft Cascade (0.2s delay between, +8→0 vertical rise)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                withAnimation(.easeOut(duration: 0.4)) {
                    proof1Opacity = 1.0
                    proof1Offset = 0
                }
            }
            
            // Proof Block 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                withAnimation(.easeOut(duration: 0.4)) {
                    proof2Opacity = 1.0
                    proof2Offset = 0
                }
            }
            
            // Proof Block 3
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation(.easeOut(duration: 0.4)) {
                    proof3Opacity = 1.0
                    proof3Offset = 0
                }
            }
            
            // Micro-Copy - Emotional Anchor (delay ~0.8s after proof blocks, max opacity 0.6)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
                withAnimation(.easeOut(duration: 0.5)) {
                    microCopyOpacity = 0.6
                }
            }
            
            // CTA Button - Invitation (fade + gentle scale 0.96→1.0, 0.45s)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                withAnimation(.easeOut(duration: 0.45)) {
                    buttonOpacity = 1.0
                    buttonScale = 1.0
                }
            }
        }
    }
}

// Avatar with online indicator component
struct AvatarWithIndicator: View {
    let opacity: Double
    let offset: CGFloat
    let gradientColors: [Color]
    let showOnline: Bool
    @State private var indicatorScale: CGFloat = 1.0
    @State private var indicatorOpacity: Double = 0.6
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
            
            // Online indicator (gentle pulse)
            if showOnline {
                Circle()
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 12, height: 12)
                    .offset(x: 20, y: -20)
                    .scaleEffect(indicatorScale)
                    .opacity(indicatorOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.75).repeatForever(autoreverses: true)) {
                            indicatorScale = 1.15
                            indicatorOpacity = 1.0
                        }
                    }
            }
        }
        .opacity(opacity)
        .offset(x: offset)
    }
}

// Community Proof component for page 3 - Soft Cascade
struct CommunityProof3: View {
    let text: String
    let opacity: Double
    let offset: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
        .opacity(opacity)
        .offset(y: offset)
    }
}

struct CommunityProof: View {
    let text: String
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.3...0.6)) {
                withAnimation(.easeOut(duration: 0.5)) {
                    appeared = true
                }
            }
        }
    }
}

// MARK: - PAGE 4: Control Through Simulation
struct OnboardingPage4Simulation: View {
    @Binding var currentPage: Int
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Clean background
            Color.white
                .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                Spacer()
                
                // UI Mockup of simulator
                VStack(spacing: 0) {
                    // Simulator header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Portfolio Value")
                                .font(.system(size: 12, weight: .regular, design: .default))
                                .foregroundColor(.gray)
                            
                            Text("$10,000.00")
                                .font(.system(size: 28, weight: .bold, design: .default))
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    
                    // Stock cards (blurred slightly)
                    VStack(spacing: 12) {
                        ForEach(["AAPL", "MSFT", "BTC"], id: \.self) { symbol in
                            HStack {
                                Text(symbol)
                                    .font(.system(size: 16, weight: .semibold, design: .default))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Text("+2.5%")
                                    .font(.system(size: 14, weight: .medium, design: .default))
                                    .foregroundColor(.green)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .blur(radius: 1)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.9)
                
                // Headline
                Text("Learn with zero risk.")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                // Subtext
                Text("Practice investing with real market data —\nwithout risking a single dollar.")
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                
                // Feature Callouts
                VStack(alignment: .leading, spacing: 16) {
                    FeatureCallout(text: "Simulators that behave like real markets")
                    FeatureCallout(text: "Lessons that explain every decision")
                    FeatureCallout(text: "Mistakes that make you smarter — not poorer")
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
                
                // Bold reassurance line
                Text("Lose here. Learn here. Win later.")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // CTA
                Button(action: {
                    withAnimation {
                        currentPage = 4
                    }
                }) {
                    Text("I like learning this way")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(showContent ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct FeatureCallout: View {
    let text: String
    @State private var appeared = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
            
            Text(text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
        }
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -20)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.3...0.6)) {
                withAnimation(.easeOut(duration: 0.5)) {
                    appeared = true
                }
            }
        }
    }
}

// MARK: - PAGE 5: Name = Identity Anchor (Personalization)
// MARK: - TypewriterText Component
struct TypewriterText: View {
    let fullText: String
    let speed: Double // milliseconds per character
    let font: Font
    let color: Color
    @Binding var isTyping: Bool
    var shouldStart: Bool = true // Trigger to start typing
    @State private var displayedText: String = ""
    @State private var hasStarted: Bool = false
    
    var body: some View {
        Text(displayedText)
            .font(font)
            .foregroundColor(color)
            .multilineTextAlignment(.center)
            .onChange(of: shouldStart) { oldValue, newValue in
                if newValue && !hasStarted {
                    startTyping()
                }
            }
            .onAppear {
                if shouldStart && !hasStarted {
                    startTyping()
                }
            }
    }
    
    private func startTyping() {
        hasStarted = true
        displayedText = ""
        typeNextCharacter(index: 0)
    }
    
    private func typeNextCharacter(index: Int) {
        guard index < fullText.count else {
            isTyping = false
            return
        }
        
        let textIndex = fullText.index(fullText.startIndex, offsetBy: index)
        displayedText = String(fullText[..<fullText.index(after: textIndex)])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed / 1000.0) {
            typeNextCharacter(index: index + 1)
        }
    }
}

// MARK: - PAGE 5: Name = Identity Anchor
struct OnboardingPage5Name: View {
    @Binding var userName: String
    @Binding var currentPage: Int
    @FocusState private var isInputFocused: Bool
    
    // Typewriter states
    @State private var headlineIsTyping: Bool = true
    @State private var headlineFinished: Bool = false
    @State private var showSubtext: Bool = false
    @State private var subtextIsTyping: Bool = true
    @State private var subtextFinished: Bool = false
    
    // Input field and other elements
    @State private var inputFieldOpacity: Double = 0
    @State private var inputFieldOffset: CGFloat = 8
    @State private var microCopyOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.97
    
    var body: some View {
        ZStack {
            // Soft gradient background - very light beige → soft warm gray
            LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.98, blue: 0.97),
                    Color(red: 0.97, green: 0.96, blue: 0.95),
                    Color(red: 0.96, green: 0.95, blue: 0.94)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .all)
            
            VStack(spacing: 0) {
                Spacer()
                
                // Headline - Conversational Entry (Typewriter Effect)
                TypewriterText(
                    fullText: "Let's make this personal.",
                    speed: 50, // 45-55ms per character (using 50ms)
                    font: .system(size: 32, weight: .bold, design: .default),
                    color: .black,
                    isTyping: $headlineIsTyping
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
                
                // Subtext - Follow-Up Question (Typewriter Effect)
                TypewriterText(
                    fullText: "What should we call you?",
                    speed: 40, // 35-45ms per character (using 40ms - slightly faster)
                    font: .system(size: 20, weight: .regular, design: .default),
                    color: .gray,
                    isTyping: $subtextIsTyping,
                    shouldStart: showSubtext
                )
                .padding(.bottom, 50)
                .opacity(showSubtext ? 1 : 0)
                
                // Input Field - Fade in + upward movement
                TextField("Your first name", text: $userName)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(userName.isEmpty ? Color.gray.opacity(0.3) : Color.blue, lineWidth: userName.isEmpty ? 1 : 2)
                    )
                    .padding(.horizontal, 40)
                    .focused($isInputFocused)
                    .opacity(inputFieldOpacity)
                    .offset(y: inputFieldOffset)
                
                // Micro-Copy - Soft Assurance
                Text("We'll use this to personalize your experience.")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.gray)
                    .padding(.top, 12)
                    .opacity(microCopyOpacity)
                
                Spacer()
                
                // CTA Button - Calm Availability
                Button(action: {
                    if !userName.isEmpty {
                        withAnimation {
                            currentPage = 5
                        }
                    }
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(userName.isEmpty ? Color.gray : Color.black)
                        .cornerRadius(12)
                }
                .disabled(userName.isEmpty)
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(buttonOpacity)
                .scaleEffect(buttonScale)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .onChange(of: headlineIsTyping) { oldValue, newValue in
            if !newValue && !headlineFinished {
                headlineFinished = true
                // Pause 300ms before subtext starts
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showSubtext = true
                }
            }
        }
        .onChange(of: subtextIsTyping) { oldValue, newValue in
            if !newValue && !subtextFinished {
                subtextFinished = true
                // Input field appears after subtext finishes
                withAnimation(.easeOut(duration: 0.4)) {
                    inputFieldOpacity = 1.0
                    inputFieldOffset = 0
                }
                // Auto-focus input field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    isInputFocused = true
                }
                // Micro-copy appears 200ms after input field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        microCopyOpacity = 0.5
                    }
                }
                // Button appears after input field (as per requirements)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 0.35)) {
                        buttonOpacity = 1.0
                        buttonScale = 1.0
                    }
                }
            }
        }
        .onChange(of: userName) { oldValue, newValue in
            // Button can also appear when user starts typing (alternative trigger)
            if buttonOpacity == 0 && !newValue.isEmpty {
                withAnimation(.easeOut(duration: 0.35)) {
                    buttonOpacity = 1.0
                    buttonScale = 1.0
                }
            }
        }
    }
}

// MARK: - Goal Selection Manager
class GoalSelectionManager: ObservableObject {
    @Published var selectedGoalIds: Set<UUID> = []
}

// MARK: - PAGE 6: Life Goal Framing
struct OnboardingPage6Goal: View {
    @Binding var selectedGoal: InvestmentGoal?
    @Binding var currentPage: Int
    @StateObject private var selectionManager = GoalSelectionManager()
    @State private var showContent = false
    @State private var shakeOffset: CGFloat = 0
    
    let goals: [InvestmentGoal] = [
        InvestmentGoal(icon: "chart.line.uptrend.xyaxis", title: "Build long-term wealth", description: ""),
        InvestmentGoal(icon: "checkmark.shield.fill", title: "Feel confident with money", description: ""),
        InvestmentGoal(icon: "sparkles", title: "Create financial freedom", description: ""),
        InvestmentGoal(icon: "brain.head.profile", title: "Understand how markets work", description: ""),
        InvestmentGoal(icon: "person.fill.checkmark", title: "Stop relying on others for decisions", description: "")
    ]
    
    var body: some View {
        ZStack {
            // Soft gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Headline
                    Text("Why do you want to learn investing?")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 12)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 10)
                    
                    // Subtext
                    Text("There's no wrong answer. This helps us guide you better.")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        .opacity(showContent ? 0.8 : 0)
                    
                    // Goal cards
                    VStack(spacing: 16) {
                        ForEach(goals) { goal in
                            SimpleGoalCard(
                                goal: goal,
                                selectionManager: selectionManager,
                                shakeOffset: selectionManager.selectedGoalIds.contains(goal.id) && shakeOffset != 0 ? shakeOffset : 0
                            ) {
                                handleCardTap(goal: goal)
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    
                    // Micro-copy
                    Text("You can change this anytime.")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(.gray)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 0.5 : 0)
                    
                    // CTA Button
                    Button(action: {
                        if !selectionManager.selectedGoalIds.isEmpty {
                            if let firstId = selectionManager.selectedGoalIds.first {
                                selectedGoal = goals.first { $0.id == firstId }
                            }
                            withAnimation {
                                currentPage = 6
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectionManager.selectedGoalIds.isEmpty ? Color.gray : Color.black)
                            .cornerRadius(12)
                    }
                    .disabled(selectionManager.selectedGoalIds.isEmpty)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .opacity(showContent ? 1 : 0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                showContent = true
            }
        }
    }
    
    private func handleCardTap(goal: InvestmentGoal) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if selectionManager.selectedGoalIds.contains(goal.id) {
            // Deselect - create new Set instance
            var newSet = selectionManager.selectedGoalIds
            newSet.remove(goal.id)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectionManager.selectedGoalIds = newSet
            }
        } else if selectionManager.selectedGoalIds.count < 2 {
            // Select - create new Set instance
            var newSet = selectionManager.selectedGoalIds
            newSet.insert(goal.id)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectionManager.selectedGoalIds = newSet
            }
        } else {
            // Max reached - shake
            withAnimation(.easeOut(duration: 0.1)) {
                shakeOffset = -8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.1)) {
                    shakeOffset = 8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.1)) {
                        shakeOffset = -8
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeOut(duration: 0.1)) {
                            shakeOffset = 0
                        }
                    }
                }
            }
        }
    }
}

// Simple, clean card component
struct SimpleGoalCard: View {
    let goal: InvestmentGoal
    @ObservedObject var selectionManager: GoalSelectionManager
    let shakeOffset: CGFloat
    let action: () -> Void
    
    var isSelected: Bool {
        selectionManager.selectedGoalIds.contains(goal.id)
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
                
                HStack(spacing: 16) {
                    Image(systemName: goal.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? .white : .blue)
                        .frame(width: 40)
                    
                    Text(goal.title)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(isSelected ? .white : .black)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: shakeOffset)
    }
}


// MARK: - Experience Selection Manager
class ExperienceSelectionManager: ObservableObject {
    @Published var selectedExperience: ExperienceLevel? = nil
}

// MARK: - PAGE 7: Experience Level (Ego-Safe)
struct OnboardingPage7Experience: View {
    @Binding var selectedExperience: ExperienceLevel?
    @Binding var currentPage: Int
    @StateObject private var selectionManager = ExperienceSelectionManager()
    @State private var showContent = false
    
    let experienceLevels: [ExperienceLevel] = [
        ExperienceLevel(title: "I'm completely new", description: "I want things explained simply."),
        ExperienceLevel(title: "I know the basics", description: "I understand some terms."),
        ExperienceLevel(title: "I've tried investing before", description: "I want structure and clarity.")
    ]
    
    var body: some View {
        ZStack {
            // Soft gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Headline
                    Text("How familiar are you with investing?")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    // Experience cards
                    VStack(spacing: 16) {
                        ForEach(experienceLevels) { level in
                            ExperienceCard(
                                level: level,
                                selectionManager: selectionManager
                            ) {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectionManager.selectedExperience = level
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    
                    // Reassurance line
                    Text("Most people start as beginners. That's expected.")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 1 : 0)
                    
                    // CTA
                    Button(action: {
                        if let selected = selectionManager.selectedExperience {
                            selectedExperience = selected
                            withAnimation {
                                currentPage = 7
                            }
                        }
                    }) {
                        Text("Got it")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectionManager.selectedExperience == nil ? Color.gray : Color.black)
                            .cornerRadius(12)
                    }
                    .disabled(selectionManager.selectedExperience == nil)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .opacity(showContent ? 1 : 0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct ExperienceCard: View {
    let level: ExperienceLevel
    @ObservedObject var selectionManager: ExperienceSelectionManager
    let action: () -> Void
    
    var isSelected: Bool {
        selectionManager.selectedExperience?.id == level.id
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(level.title)
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(isSelected ? .white : .black)
                        
                        Text(level.description)
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Time Selection Manager
class TimeSelectionManager: ObservableObject {
    @Published var selectedTimeCommitment: TimeCommitment? = nil
}

// MARK: - PAGE 8: Time Commitment (Realistic Control)
struct OnboardingPage8Time: View {
    @Binding var selectedTimeCommitment: TimeCommitment?
    @Binding var currentPage: Int
    @StateObject private var selectionManager = TimeSelectionManager()
    @State private var showContent = false
    
    let timeOptions: [TimeCommitment] = [
        TimeCommitment(title: "5 minutes a day"),
        TimeCommitment(title: "10–15 minutes a day"),
        TimeCommitment(title: "I want a deeper learning pace")
    ]
    
    var body: some View {
        ZStack {
            // Soft gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Headline
                    Text("How much time can you realistically invest?")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    // Time commitment cards
                    VStack(spacing: 16) {
                        ForEach(timeOptions) { option in
                            TimeCommitmentCard(
                                option: option,
                                selectionManager: selectionManager
                            ) {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectionManager.selectedTimeCommitment = option
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    
                    // Supporting text
                    Text("Consistency matters more than intensity.")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 1 : 0)
                    
                    // CTA
                    Button(action: {
                        if let selected = selectionManager.selectedTimeCommitment {
                            selectedTimeCommitment = selected
                            withAnimation {
                                currentPage = 8
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectionManager.selectedTimeCommitment == nil ? Color.gray : Color.black)
                            .cornerRadius(12)
                    }
                    .disabled(selectionManager.selectedTimeCommitment == nil)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .opacity(showContent ? 1 : 0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct TimeCommitmentCard: View {
    let option: TimeCommitment
    @ObservedObject var selectionManager: TimeSelectionManager
    let action: () -> Void
    
    var isSelected: Bool {
        selectionManager.selectedTimeCommitment?.id == option.id
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
                
                HStack {
                    Text(option.title)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(isSelected ? .white : .black)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - PAGE 9: Risk Mindset (Emotional Framing)
struct OnboardingPage9Risk: View {
    @Binding var selectedRiskMindset: RiskMindset?
    @Binding var currentPage: Int
    @State private var showContent = false
    @State private var localSelectedRiskMindset: RiskMindset? = nil
    
    let riskOptions: [RiskMindset] = [
        RiskMindset(title: "I'm cautious — I want to understand first"),
        RiskMindset(title: "I'm open, but I want structure"),
        RiskMindset(title: "I'm curious and willing to experiment")
    ]
    
    var body: some View {
        ZStack {
            // Soft gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.98, blue: 1.0),
                    Color.white
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .all)
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Headline
                    Text("How do you feel about risk?")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    // Risk mindset cards
                    VStack(spacing: 16) {
                        ForEach(riskOptions) { option in
                            RiskMindsetCard(
                                option: option,
                                isSelected: localSelectedRiskMindset?.id == option.id
                            ) {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    localSelectedRiskMindset = option
                                    selectedRiskMindset = option
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    
                    // Subtext
                    Text("Your learning path will reflect this.")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .padding(.bottom, 40)
                        .opacity(showContent ? 1 : 0)
                    
                    // CTA
                    Button(action: {
                        if localSelectedRiskMindset != nil {
                            withAnimation {
                                currentPage = 9
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(localSelectedRiskMindset == nil ? Color.gray : Color.black)
                            .cornerRadius(12)
                    }
                    .disabled(localSelectedRiskMindset == nil)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                    .opacity(showContent ? 1 : 0)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct RiskMindsetCard: View {
    let option: RiskMindset
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.black : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                    )
                
                HStack {
                    Text(option.title)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(isSelected ? .white : .black)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - PAGE 10: Commitment Moment (Emotional Contract)
struct OnboardingPage10Commitment: View {
    let userName: String
    let selectedGoal: InvestmentGoal?
    let selectedExperience: ExperienceLevel?
    let selectedTimeCommitment: TimeCommitment?
    @Binding var storedUserName: String
    @Binding var isOnboardingComplete: Bool
    
    // Animation states
    @State private var headlineOpacity: Double = 0
    @State private var headlineOffset: CGFloat = -12
    @State private var subtextOpacity: Double = 0
    @State private var summaryCardOpacity: Double = 0
    @State private var summaryRow1Opacity: Double = 0
    @State private var summaryRow1Offset: CGFloat = 8
    @State private var summaryRow2Opacity: Double = 0
    @State private var summaryRow2Offset: CGFloat = 8
    @State private var summaryRow3Opacity: Double = 0
    @State private var summaryRow3Offset: CGFloat = 8
    @State private var emotionalLineOpacity: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.96
    
    // Floating orbs animation states
    @State private var orb1OffsetY: CGFloat = 0
    @State private var orb1OffsetX: CGFloat = 0
    @State private var orb2OffsetY: CGFloat = 0
    @State private var orb2OffsetX: CGFloat = 0
    @State private var orb3OffsetY: CGFloat = 0
    @State private var orb3OffsetX: CGFloat = 0
    @State private var orb4OffsetY: CGFloat = 0
    @State private var orb4OffsetX: CGFloat = 0
    @State private var orb5OffsetY: CGFloat = 0
    @State private var orb5OffsetX: CGFloat = 0
    
    // CTA tap effect states
    @State private var buttonPressed: Bool = false
    @State private var screenFade: Double = 0
    @State private var glowScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Minimal warm off-white background
            Color(red: 0.99, green: 0.98, blue: 0.97)
                .ignoresSafeArea(edges: .all)
            
            GeometryReader { geometry in
                // Floating Commitment Orbs (top third of screen)
                let topThirdY = geometry.size.height * 0.33
                
                // Orb 1 - Soft blue
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .blur(radius: 8)
                    .position(x: geometry.size.width * 0.2, y: topThirdY + orb1OffsetY)
                    .offset(x: orb1OffsetX)
                    .opacity(0.1)
                
                // Orb 2 - Soft green
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .blur(radius: 6)
                    .position(x: geometry.size.width * 0.4, y: topThirdY + 20 + orb2OffsetY)
                    .offset(x: orb2OffsetX)
                    .opacity(0.1)
                
                // Orb 3 - Soft blue
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 70, height: 70)
                    .blur(radius: 7)
                    .position(x: geometry.size.width * 0.6, y: topThirdY - 15 + orb3OffsetY)
                    .offset(x: orb3OffsetX)
                    .opacity(0.12)
                
                // Orb 4 - Soft green
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 55, height: 55)
                    .blur(radius: 5)
                    .position(x: geometry.size.width * 0.8, y: topThirdY + 10 + orb4OffsetY)
                    .offset(x: orb4OffsetX)
                    .opacity(0.08)
                
                // Orb 5 - Soft blue
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 65, height: 65)
                    .blur(radius: 6)
                    .position(x: geometry.size.width * 0.5, y: topThirdY + 30 + orb5OffsetY)
                    .offset(x: orb5OffsetX)
                    .opacity(0.1)
            }
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)
                
                // Headline - Personal Recognition
                Text("Alright, \(userName.isEmpty ? "there" : userName).")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .opacity(headlineOpacity)
                    .offset(y: headlineOffset)
                
                // Subtext - System Responding
                Text("Based on what you told us,\nwe're building your personal learning path.")
                    .font(.system(size: 18, weight: .regular, design: .default))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    .opacity(subtextOpacity)
                
                // Summary Card - Assembled, Not Shown
                VStack(alignment: .leading, spacing: 16) {
                    if let goal = selectedGoal {
                        SummaryRow(
                            label: "Goal:",
                            value: goal.title,
                            opacity: summaryRow1Opacity,
                            offset: summaryRow1Offset
                        )
                    }
                    if let experience = selectedExperience {
                        SummaryRow(
                            label: "Level:",
                            value: experience.title,
                            opacity: summaryRow2Opacity,
                            offset: summaryRow2Offset
                        )
                    }
                    if let time = selectedTimeCommitment {
                        SummaryRow(
                            label: "Pace:",
                            value: time.title,
                            opacity: summaryRow3Opacity,
                            offset: summaryRow3Offset
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.08))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(summaryCardOpacity)
                
                // Emotional Line - Quiet but Strong
                Text("You're not here to gamble.\nYou're here to learn a skill.")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    .opacity(emotionalLineOpacity)
                
                Spacer()
                
                // CTA Button - Subtle Power
                Button(action: {
                    handleCTATap()
                }) {
                    ZStack {
                        // Glow effect on tap
                        if buttonPressed {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                                .blur(radius: 20)
                                .scaleEffect(glowScale)
                        }
                        
                        Text("Create my learning path")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(buttonPressed ? Color.black.opacity(0.8) : Color.black)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
                .opacity(buttonOpacity)
                .scaleEffect(buttonScale)
            }
            
            // Screen fade overlay on CTA tap
            if buttonPressed {
                Color.white.opacity(screenFade)
                    .ignoresSafeArea(edges: .all)
            }
        }
        .onAppear {
            startAnimations()
            startFloatingOrbs()
        }
    }
    
    private func startAnimations() {
        // Headline - Fade in + downward settle
        withAnimation(.easeOut(duration: 0.6)) {
            headlineOpacity = 1.0
            headlineOffset = 0
        }
        
        // Subtext - Fade in only (delay 0.3s)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                subtextOpacity = 0.85
            }
        }
        
        // Summary card fade in (delay 0.8s after headline)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.4)) {
                summaryCardOpacity = 1.0
            }
            
            // Then animate each row one by one
            // Row 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeOut(duration: 0.35)) {
                    summaryRow1Opacity = 1.0
                    summaryRow1Offset = 0
                }
            }
            
            // Row 2 (if exists)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 0.35)) {
                    summaryRow2Opacity = 1.0
                    summaryRow2Offset = 0
                }
            }
            
            // Row 3 (if exists)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.easeOut(duration: 0.35)) {
                    summaryRow3Opacity = 1.0
                    summaryRow3Offset = 0
                }
                
                // Emotional line appears after summary completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        emotionalLineOpacity = 0.7
                    }
                }
            }
        }
        
        // CTA button - Fade in + scale (appears after subtext)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeOut(duration: 0.45)) {
                buttonOpacity = 1.0
                buttonScale = 1.0
            }
        }
    }
    
    private func startFloatingOrbs() {
        // Orb 1 - Vertical ±10px, Horizontal ±6px, 22s
        withAnimation(.easeInOut(duration: 22).repeatForever(autoreverses: true)) {
            orb1OffsetY = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 18).repeatForever(autoreverses: true)) {
                orb1OffsetX = 6
            }
        }
        
        // Orb 2 - Different speeds
        withAnimation(.easeInOut(duration: 26).repeatForever(autoreverses: true)) {
            orb2OffsetY = -8
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 20).repeatForever(autoreverses: true)) {
                orb2OffsetX = -5
            }
        }
        
        // Orb 3
        withAnimation(.easeInOut(duration: 24).repeatForever(autoreverses: true)) {
            orb3OffsetY = 9
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 19).repeatForever(autoreverses: true)) {
                orb3OffsetX = 4
            }
        }
        
        // Orb 4
        withAnimation(.easeInOut(duration: 28).repeatForever(autoreverses: true)) {
            orb4OffsetY = -10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 21).repeatForever(autoreverses: true)) {
                orb4OffsetX = -6
            }
        }
        
        // Orb 5
        withAnimation(.easeInOut(duration: 25).repeatForever(autoreverses: true)) {
            orb5OffsetY = 7
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 23).repeatForever(autoreverses: true)) {
                orb5OffsetX = 5
            }
        }
    }
    
    private func handleCTATap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Immediate feedback - button darkens and scales down
        withAnimation(.easeOut(duration: 0.1)) {
            buttonPressed = true
            buttonScale = 0.94
        }
        
        // Glow expands outward
        withAnimation(.easeOut(duration: 0.4)) {
            glowScale = 3.0
        }
        
        // Screen fades and circles drift upward
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.5)) {
                screenFade = 0.9
                orb1OffsetY -= 30
                orb2OffsetY -= 25
                orb3OffsetY -= 35
                orb4OffsetY -= 28
                orb5OffsetY -= 32
            }
            
            // Complete onboarding after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                storedUserName = userName
                isOnboardingComplete = true
            }
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    let opacity: Double
    let offset: CGFloat
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold, design: .default))
                .foregroundColor(.black)
            
            Text(value)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(.gray)
            
            Spacer()
        }
        .opacity(opacity)
        .offset(x: offset)
    }
}


