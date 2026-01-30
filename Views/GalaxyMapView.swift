import SwiftUI

struct GalaxyMapView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedMode: GameMode?
    @State private var showSidePanel = false
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GalaxyBackgroundView()
                
                // Planet nodes
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    ZStack {
                        // Easy Planet (top-left)
                        PlanetNodeView(mode: .easy)
                            .position(x: width * 0.3, y: height * 0.25)
                            .onTapGesture {
                                selectedMode = .easy
                                navigateToGame = true
                            }
                        
                        // Moderate Planet (top-right)
                        PlanetNodeView(mode: .moderate)
                            .position(x: width * 0.7, y: height * 0.3)
                            .onTapGesture {
                                selectedMode = .moderate
                                navigateToGame = true
                            }
                        
                        // Hard Planet (bottom-left)
                        PlanetNodeView(mode: .hard)
                            .position(x: width * 0.25, y: height * 0.65)
                            .onTapGesture {
                                selectedMode = .hard
                                navigateToGame = true
                            }
                        
                        // Bonus Planet (bottom-right)
                        PlanetNodeView(mode: .bonus)
                            .position(x: width * 0.75, y: height * 0.7)
                            .onTapGesture {
                                // Coming soon message
                            }
                    }
                }
                .padding()
                
                // Top bar
                VStack {
                    HStack {
                        // Menu button
                        Button(action: {
                            withAnimation {
                                showSidePanel = true
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // Profile icon
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(authViewModel.user?.name ?? "Player")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Tap a planet to play")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.cyan)
                    }
                    .padding()
                    
                    Spacer()
                }
                
                // Side panel overlay
                if showSidePanel {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showSidePanel = false
                            }
                        }
                    
                    SidePanelView(isShowing: $showSidePanel)
                        .transition(.move(edge: .leading))
                }
            }
            .navigationDestination(isPresented: $navigateToGame) {
                if let mode = selectedMode {
                    GameView(mode: mode)
                }
            }
        }
    }
}

#Preview {
    GalaxyMapView()
        .environmentObject(AuthViewModel())
}
