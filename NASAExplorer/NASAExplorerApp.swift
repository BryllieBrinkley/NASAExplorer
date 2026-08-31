import SwiftUI
import SwiftData 
@main
struct NASAExplorerApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    RootTabView()
                        .transition(.opacity)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(6))
                
                withAnimation(.easeInOut(duration: 0.6)) {
                    showSplash = false
                }
            }
        }
        .modelContainer(for: SavedNASAItem.self)
        
        
        
    }
    
}
