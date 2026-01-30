import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    var isLoggedIn: Bool {
        user != nil
    }
    
    init() {
        // Listen for auth state changes
        authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            if let firebaseUser = firebaseUser {
                print("🔵 Auth state changed: User logged in - \(firebaseUser.uid)")
                // User is signed in, fetch their profile
                self?.fetchUserProfile(userId: firebaseUser.uid)
            } else {
                print("🔵 Auth state changed: User logged out")
                // User is signed out
                self?.user = nil
            }
        }
    }
    
    deinit {
        if let handler = authStateHandler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
    
    // MARK: - Authentication Methods
    
    func signUp(email: String, password: String, name: String) async {
        print("🔵 Starting sign up for: \(email)")
        await MainActor.run { isLoading = true }
        
        do {
            print("🔵 Creating Firebase Auth user...")
            // Create Firebase Auth user
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            print("✅ Firebase user created with ID: \(result.user.uid)")
            
            // Create user profile in Firestore
            let userProfile = UserProfile(
                id: result.user.uid,
                name: name,
                email: email,
                acceptedPrivacy: true
            )
            
            print("🔵 Saving user profile to Firestore...")
            try await saveUserProfile(userProfile)
            print("✅ User profile saved!")
            
            await MainActor.run {
                self.user = userProfile
                self.isLoading = false
                self.errorMessage = nil
                print("✅ Sign up complete! User: \(userProfile.name)")
            }
        } catch {
            print("❌ Sign up error: \(error.localizedDescription)")
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        print("🔵 Starting sign in for: \(email)")
        await MainActor.run { isLoading = true }
        
        do {
            print("🔵 Signing in with Firebase...")
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            print("✅ Firebase sign in successful! UID: \(result.user.uid)")
            
            // Fetch user profile from Firestore
            print("🔵 Fetching user profile...")
            await fetchUserProfile(userId: result.user.uid)
            
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = nil
                print("✅ Sign in complete!")
            }
        } catch {
            print("❌ Sign in error: \(error.localizedDescription)")
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
            print("✅ User signed out")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Sign out error: \(error.localizedDescription)")
        }
    }
    
    func updateProfile(name: String) {
        guard var currentUser = user else { return }
        currentUser.name = name
        user = currentUser
        
        Task {
            try? await saveUserProfile(currentUser)
        }
    }
    
    // MARK: - Firestore Methods
    
    private func saveUserProfile(_ profile: UserProfile) async throws {
        let data: [String: Any] = [
            "id": profile.id,
            "name": profile.name,
            "email": profile.email,
            "createdAt": Timestamp(date: profile.createdAt),
            "totalGamesPlayed": profile.totalGamesPlayed,
            "highestScore": profile.highestScore,
            "acceptedPrivacy": profile.acceptedPrivacy
        ]
        
        print("🔵 Saving to Firestore: users/\(profile.id)")
        try await db.collection("users").document(profile.id).setData(data)
        print("✅ Firestore save successful")
    }
    
    private func fetchUserProfile(userId: String) {
        Task {
            do {
                print("🔵 Fetching user profile from Firestore: \(userId)")
                let snapshot = try await db.collection("users").document(userId).getDocument()
                
                if let data = snapshot.data() {
                    print("✅ User profile data retrieved")
                    let profile = UserProfile(
                        id: data["id"] as? String ?? userId,
                        name: data["name"] as? String ?? "Player",
                        email: data["email"] as? String ?? "",
                        createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                        acceptedPrivacy: data["acceptedPrivacy"] as? Bool ?? false,
                        totalGamesPlayed: data["totalGamesPlayed"] as? Int ?? 0,
                        highestScore: data["highestScore"] as? Int ?? 0
                    )
                    
                    await MainActor.run {
                        self.user = profile
                        print("✅ User profile loaded: \(profile.name)")
                    }
                } else {
                    print("⚠️ No user profile found in Firestore")
                }
            } catch {
                print("❌ Error fetching user profile: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Update Stats
    
    func updateGameStats(score: Int) async {
        guard var currentUser = user else { return }
        
        currentUser.totalGamesPlayed += 1
        if score > currentUser.highestScore {
            currentUser.highestScore = score
        }
        
        user = currentUser
        
        do {
            try await db.collection("users").document(currentUser.id).updateData([
                "totalGamesPlayed": currentUser.totalGamesPlayed,
                "highestScore": currentUser.highestScore
            ])
            print("✅ Game stats updated")
        } catch {
            print("❌ Error updating stats: \(error.localizedDescription)")
        }
    }
}
