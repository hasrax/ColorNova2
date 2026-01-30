import SwiftUI

struct SidePanelView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToLeaderboard = false
    @State private var navigateToAchievements = false
    @State private var navigateToProfile = false
    @State private var navigateToHowToPlay = false  // ADDED
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("🌌 Color Nova")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    
                    Text(authViewModel.user?.name ?? "Player")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .padding(.top, 40)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                    .padding(.vertical, 10)
                
                // Menu items
                VStack(spacing: 5) {
                    SidePanelButton(
                        icon: "trophy.fill",
                        title: "Leaderboard",
                        color: .yellow
                    ) {
                        navigateToLeaderboard = true
                        isShowing = false
                    }
                    
                    SidePanelButton(
                        icon: "star.fill",
                        title: "Achievements",
                        color: .cyan  // Changed from purple
                    ) {
                        navigateToAchievements = true
                        isShowing = false
                    }
                    
                    SidePanelButton(
                        icon: "person.fill",
                        title: "Profile",
                        color: .blue  // Changed from cyan
                    ) {
                        navigateToProfile = true
                        isShowing = false
                    }
                    
                    SidePanelButton(
                        icon: "info.circle.fill",
                        title: "How to Play",
                        color: .green
                    ) {
                        navigateToHowToPlay = true  // ADDED
                        isShowing = false
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Sign Out button
                Button(action: {
                    authViewModel.signOut()
                    isShowing = false
                }) {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.red)
                        Text("Sign Out")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(10)
                }
                .padding()
                .padding(.bottom, 30)
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.1, blue: 0.2),  // Less purple, more blue
                        Color(red: 0.1, green: 0.15, blue: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1),
                alignment: .trailing
            )
            
            Spacer()
        }
        .background(
            NavigationLink(destination: LeaderboardView(), isActive: $navigateToLeaderboard) {
                EmptyView()
            }
            .hidden()
        )
        .background(
            NavigationLink(destination: AchievementsView(), isActive: $navigateToAchievements) {
                EmptyView()
            }
            .hidden()
        )
        .background(
            NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) {
                EmptyView()
            }
            .hidden()
        )
        .background(
            NavigationLink(destination: HowToPlayView(), isActive: $navigateToHowToPlay) {  // ADDED
                EmptyView()
            }
            .hidden()
        )
    }
}

struct SidePanelButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
                    .font(.caption)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
    }
}

#Preview {
    SidePanelView(isShowing: .constant(true))
        .environmentObject(AuthViewModel())
}
