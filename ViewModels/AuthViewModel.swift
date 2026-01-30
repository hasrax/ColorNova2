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
            fetchUserProfile(userId: result.user.uid)
            
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
        
        Task {
            try? await saveUserProfile(currentUser)
            await MainActor.run {
                self.user = currentUser
            }
        }
    }
    
    // MARK: - Firestore Methods
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        let data: [String: Any] = [
            "name": profile.name,
            "email": profile.email,
            "createdAt": Timestamp(date: profile.createdAt),
            "acceptedPrivacy": profile.acceptedPrivacy,
            "totalGamesPlayed": profile.totalGamesPlayed,  // Fixed property name
            "highestScore": profile.highestScore  // Fixed property name
        ]
        
        try await db.collection("users").document(profile.id).setData(data, merge: true)
    }
    
    func fetchUserProfile(userId: String) {
        Task {
            do {
                let document = try await db.collection("users").document(userId).getDocument()
                
                if let data = document.data() {
                    print("🔵 User profile data found: \(data)")
                    
                    // Handle createdAt date
                    let createdAt: Date
                    if let timestamp = data["createdAt"] as? Timestamp {
                        createdAt = timestamp.dateValue()
                    } else {
                        createdAt = Date()
                    }
                    
                    let profile = UserProfile(
                        id: userId,
                        name: data["name"] as? String ?? "Unknown",
                        email: data["email"] as? String ?? "",
                        createdAt: createdAt,
                        acceptedPrivacy: data["acceptedPrivacy"] as? Bool ?? false,
                        totalGamesPlayed: data["totalGamesPlayed"] as? Int ?? 0,  // Fixed property name
                        highestScore: data["highestScore"] as? Int ?? 0  // Fixed property name
                    )
                    await MainActor.run {
                        self.user = profile
                        print("✅ User profile loaded: \(profile.name)")
                    }
                } else {
                    print("⚠️ No user profile found in Firestore for ID: \(userId)")
                }
            } catch {
                print("❌ Error fetching user profile: \(error.localizedDescription)")
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateGameStats(score: Int) async {
        guard var currentUser = user else { return }
        
        // Update total games played
        currentUser.totalGamesPlayed += 1  // Fixed property name
        
        // Update highest score if current score is higher
        if score > currentUser.highestScore {  // Fixed property name
            currentUser.highestScore = score  // Fixed property name
        }
        
        do {
            try await saveUserProfile(currentUser)
            await MainActor.run {
                self.user = currentUser
            }
        } catch {
            print("❌ Error updating game stats: \(error.localizedDescription)")
        }
    }
}
