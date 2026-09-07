import Foundation
import Observation

@Observable
final class ExploreViewModel {
    
    private(set) var results: [NASAItem] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil
    
    private let mediaService: NASAMediaService
    
    init(mediaService: NASAMediaService) {
        self.mediaService = mediaService
    }
    
    
    func searchNASAMedia(query: String) async {
        guard !query.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            results = try await mediaService.fetchNASAMedia(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
