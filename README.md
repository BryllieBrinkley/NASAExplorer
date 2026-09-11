# NASA Media Explorer
A lightweight, iOS app that I built to browse and search the NASA gallery of photos and videos with clean UI, smooth image loading, and simple saving/sharing workflows. Not endorsed or officially affiliated with NASA in any way, shape, or form. Happy exploring!

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

# Screenshots 


<img width="115" height="250" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-09-11 at 17 43 29" src="https://github.com/user-attachments/assets/a771e773-29ef-45ff-a063-55cd933dfa63" />
<img width="115" height="250" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-09-11 at 17 43 14" src="https://github.com/user-attachments/assets/21ab161c-fd2c-4d63-8cc1-2f441a8b3346" />
<img width="115" height="250" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-09-11 at 17 42 56" src="https://github.com/user-attachments/assets/3158903d-c0d0-425a-bdd8-fc279fe40b4e" />

<br>

<img width="137" height="250" alt="IMG_3257" src="https://github.com/user-attachments/assets/0cbadd54-cd65-42d9-8237-83b209321c93" />
<img width="125" height="250" alt="IMG_3255" src="https://github.com/user-attachments/assets/119843b3-866b-4ff9-b163-714b5ca2bcef" />
<img width="138" height="250" alt="IMG_3260" src="https://github.com/user-attachments/assets/5ae1dd77-a480-4308-a90b-a63165180572" />



Keywords: Swift, SwiftUI, SwiftData, async/await, Concurrency, MVVM, iOS, iPadOS, NavigationStack, ShareLink, AsyncImage, ModelContext, ModelContainer, Persistence, REST, JSON, NASA API, URLSession, Custom App Theming, App Architecture
