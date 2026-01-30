import SwiftUI

struct SidePanelView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToLeaderboard = false
    @State private var navigateToAchievements = false
    @State private var navigateToProfile = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("🌌 ColorNova2")
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
                        color: .purple
                    ) {
                        navigateToAchievements = true
                        isShowing = false
                    }
                    
                    SidePanelButton(
                        icon: "person.fill",
                        title: "Profile",
                        color: .cyan
                    ) {
                        navigateToProfile = true
                        isShowing = false
                    }
                    
                    SidePanelButton(
                        icon: "info.circle.fill",
                        title: "How to Play",
                        color: .green
                    ) {
                        // TODO: Show tutorial
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
                        Color(red: 0.1, green: 0.05, blue: 0.2),
                        Color(red: 0.15, green: 0.1, blue: 0.25)
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
    }
}

struct SidePanelButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
    }
}

#Preview {
    ZStack {
        GalaxyBackgroundView()
        SidePanelView(isShowing: .constant(true))
            .environmentObject(AuthViewModel())
    }
}
