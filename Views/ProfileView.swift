import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 0) {
                // Header - FIXED at top
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Text("👤 Profile")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Color.clear.frame(width: 50)
                }
                .frame(height: 60)
                .background(Color.black.opacity(0.3))
                
                // Content - MORE SPACE
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile info
                        if let user = authViewModel.user {
                            VStack(spacing: 15) {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.cyan)
                                
                                Text(user.name)
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.top, 20)
                            
                            // Stats
                            VStack(spacing: 12) {
                                StatRow(label: "Games Played", value: "\(user.totalGamesPlayed)", icon: "gamecontroller.fill", color: .cyan)
                                StatRow(label: "Highest Score", value: "\(user.highestScore)", icon: "star.fill", color: .yellow)
                                StatRow(label: "Member Since", value: user.createdAt.formatted(date: .abbreviated, time: .omitted), icon: "calendar", color: .green)
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StatRow: View {
    let label: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(label)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
