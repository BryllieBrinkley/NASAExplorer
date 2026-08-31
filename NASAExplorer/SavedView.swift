import SwiftUI
import SwiftData

struct SavedView: View {
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            AppColors.spaceGradient
                .ignoresSafeArea()
            
        NavigationView {
            
                ScrollView {
                    ForEach(1..<10) { num in
                        Text("\(num)")
                    
//                        NASASearchResultCard(item: modelContext.container.)
//                        
                        
                    }
                }
                
            }
            
        }
        .padding()
    }
}

#Preview {
    SavedView()
}
