import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                GalaxyBackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("ColorNova2 Privacy Policy")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        Group {
                            SectionView(
                                title: "Information We Collect",
                                content: """
                                We collect the following information:
                                • Email address for authentication
                                • Display name for leaderboards
                                • Game scores and achievements
                                • Date and time of gameplay
                                """
                            )
                            
                            SectionView(
                                title: "How We Use Your Information",
                                content: """
                                We use your information to:
                                • Authenticate your account
                                • Display your scores on leaderboards
                                • Track your achievements
                                • Improve game experience
                                """
                            )
                            
                            SectionView(
                                title: "Data Storage",
                                content: """
                                We use Firebase Authentication and Firestore to securely store your data. Your data is encrypted and protected according to industry standards.
                                """
                            )
                            
                            SectionView(
                                title: "Data Sharing",
                                content: """
                                We do NOT share your personal information with third parties. Your email address is private. Only your display name and scores are visible on public leaderboards.
                                """
                            )
                            
                            SectionView(
                                title: "Your Rights",
                                content: """
                                You have the right to:
                                • Access your personal data
                                • Request data deletion
                                • Update your information
                                • Opt out of leaderboards
                                
                                To exercise these rights, contact us at: support@colornova2.com
                                """
                            )
                            
                            SectionView(
                                title: "Updates to This Policy",
                                content: """
                                We may update this privacy policy from time to time. Continued use of the app constitutes acceptance of any changes.
                                
                                Last updated: January 2026
                                """
                            )
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.cyan)
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}

#Preview {
    PrivacyPolicyView()
}
