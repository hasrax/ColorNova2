import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var editName = ""
    @State private var isEditingName = false
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    // Profile icon
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan.opacity(0.5), radius: 20)
                    
                    // Name
                    if isEditingName {
                        HStack {
                            TextField("Name", text: $editName)
                                .textFieldStyle(GalaxyTextFieldStyle())
                            
                            Button("Save") {
                                authViewModel.updateProfile(name: editName)
                                isEditingName = false
                            }
                            .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                    } else {
                        HStack {
                            Text(authViewModel.user?.name ?? "Player")
                                .font(.title.bold())
                                .foregroundColor(.white)
                            
                            Button(action: {
                                editName = authViewModel.user?.name ?? ""
                                isEditingName = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.cyan)
                            }
                        }
                    }
                    
                    Text(authViewModel.user?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                    
                    // Stats
                    VStack(spacing: 15) {
                        StatRowView(
                            icon: "gamecontroller.fill",
                            label: "Games Played",
                            value: "\(authViewModel.user?.totalGamesPlayed ?? 0)",
                            color: .purple
                        )
                        
                        StatRowView(
                            icon: "star.fill",
                            label: "Highest Score",
                            value: "\(authViewModel.user?.highestScore ?? 0)",
                            color: .yellow
                        )
                        
                        StatRowView(
                            icon: "calendar",
                            label: "Member Since",
                            value: authViewModel.user?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "",
                            color: .cyan
                        )
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StatRowView: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
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
