# NASA Media Viewer (SwiftUI + SwiftData)

A modern iOS app to browse and preview NASA media with clean UI, smooth image loading, and simple saving/sharing workflows. Not endorsed or officially affiliated with NASA in any way, shape, or form.
## Highlights

- SwiftUI-first architecture with Swift Concurrency
- SwiftData for lightweight persistence (ModelContext/ModelContainer)
- Async image loading with graceful placeholders and progress indicators
- Native sharing via ShareLink
- Clean navigation using NavigationStack with inline titles
- Custom theming through an AppColors palette
- Preview-driven development with #Preview
- Models for NASA API data points (e.g., NASAItem, NASAImageData, NASAImageLink) and saved items

## Features

- Browse NASA media and view high-resolution previews
- Save favorite items locally using SwiftData
- Share media links with the system share sheet
- Responsive UI with loading states and fallback placeholders

## Tech Stack

- Languages: Swift 6
- UI: SwiftUI (Views, NavigationStack, Toolbar customization), Xcode Previews (#Preview)
- Concurrency: async/await (Swift Concurrency)
- Persistence: SwiftData (ModelContext, ModelContainer)
- System Services: ShareLink (UIActivityViewController), AsyncImage
- Foundation: URL, JSON, AttributedString-ready
- Networking: REST/JSON via URLSession (planned), caching/prefetching (planned)
- Architecture: MVVM-leaning SwiftUI, stateless views, dependency seams for networking
- Tooling: Xcode, iOS/iPadOS targets

## Code Tour

- NASAItemDetailView: Displays media details, preview image, metadata (title, description, NASA ID), plus Save and Share actions
- SavedItemsManager: Encapsulates persistence operations using SwiftData
- AppColors: Centralized color system for consistent theming
- Strong type modeling for NASA API entities (NASAItem, NASAImageData, NASAImageLink) and persisted SavedNASAItem

## Architecture

- MVVM-leaning SwiftUI structure (Views + Managers/Models)
- Single source of truth via SwiftData and Environment ModelContext
- Stateless views with data-driven rendering
- Dependency seams for future networking layer (protocol-friendly)

## Why It Matters

- Demonstrates modern iOS patterns and best practices
- Prioritizes performance, UX polish, and maintainability
- Readable, testable components suitable for team environments

## Getting Started

- Requirements: Xcode 15+ (or latest), iOS 17+
- Open the project in Xcode and run on a device or simulator
- The app ships with preview/sample data for immediate UI testing

## Roadmap

- Live NASA API integration with search and pagination
- Offline caching and image prefetching
- Advanced filtering and keyword-based discovery
- Swift Testing/XCTest for view models and persistence logic


Keywords: Swift, SwiftUI, SwiftData, async/await, Concurrency, MVVM, iOS, iPadOS, NavigationStack, ShareLink, AsyncImage, ModelContext, ModelContainer, Persistence, REST, JSON, NASA API, URLSession, Custom App Theming, App Architecture
