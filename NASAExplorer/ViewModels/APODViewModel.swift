import Foundation
import SwiftUI
import Combine

@MainActor
final class APODViewModel: ObservableObject {
    @Published var picture: PictureOfDay?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isExpanded = false

    private let service: APODServicing

    init(service: APODServicing = APODService()) {
        self.service = service
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let pod = try await service.fetchAPOD()
            picture = pod
            service.cacheAPOD(pod)
        } catch {
            if let cached = service.fetchCachedAPOD() {
                picture = cached
                errorMessage = "Showing last saved APOD due to network issues."
            } else {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }
}
