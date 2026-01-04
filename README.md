# 📰 NewsApp (SwiftUI + MVVM)

A simple News application built with **SwiftUI**, **MVVM**, and **Swift Concurrency**, consuming the **NewsAPI** to display headlines, sources, and saved articles with local persistence.

---

## 📌 Setup Instructions

1. **Clone the repository**

```bash
git clone <your-repo-url>
cd NewsApp
```

2. **Add your NewsAPI key**

Open `Configuration.swift` and update:

```swift
enum Configuration {
    static let newsAPIKey = "YOUR_API_KEY_HERE"
}
```

You can obtain a free API key from:  
👉 https://newsapi.org/

3. **Build & Run**


---

## 🧱 Architecture Overview

The project follows a **Clean MVVM-inspired structure**, with clear separation between **Domain**, **Data**, and **Presentation** layers.

```
NewsApp
├── App
│   └── NewsApp.swift
├── Domain
│   ├── Models
│   │   ├── Article.swift
│   │   └── Source.swift
│   └── Protocols
│       ├── NewsService.swift
│       └── PersistenceStore.swift
├── Data
│   ├── Network
│   │   └── NewsAPIService.swift
│   └── Persistence
│       ├── UserDefaultsSourceStore.swift
│       └── FileSavedArticlesStore.swift
├── Presentation
│   ├── ViewModels
│   │   ├── HeadlinesViewModel.swift
│   │   ├── SourcesViewModel.swift
│   │   └── SavedArticlesViewModel.swift
│   └── Views
│       ├── MainTabView.swift
│       ├── HeadlinesView.swift
│       ├── SourcesView.swift
│       ├── SavedView.swift
│       └── WebView.swift
└── Tests
    ├── MockNewsService.swift
    └── HeadlinesViewModelTests.swift
```

---

## 🧠 Design Decisions

### MVVM + SwiftUI
- Views are **stateless**
- Business logic lives in `ViewModel`s
- State is driven via `@Published` and observed with `@ObservedObject` / `@StateObject`

### Protocol-Oriented Design
- `NewsService`, `SourcesStore`, and `SavedArticlesStore` are protocols
- Enables easy mocking and testability
- Allows swapping implementations (e.g. CoreData later)

### Persistence
- **Sources selection** → `UserDefaults`
- **Saved articles** → JSON file in Documents directory
- Articles are uniquely identified by `url.absoluteString`



---

## 📦 Swift Packages

The project uses two local Swift Packages:

### `MBNetworking`
- Lightweight networking abstraction
- Wraps `URLSession.shared`
- Handles request building, decoding, and HTTP validation
- Used by `NewsAPIService`

### `MBUILibrary`
- Reusable SwiftUI components
- Keeps presentation code clean and modular
- Easy to reuse across features

---

## 🧪 Testing Strategy

The project includes **unit tests for ViewModels and persistence logic**.

### Highlights
- No reliance on `UserDefaults.standard` or real file system
- Reusable mocks for:
  - `NewsService`
  - `SourcesStore`
  - `SavedArticlesStore`
- Deterministic, isolated tests

---

## 📱 App Features

### Headlines Tab
- Displays articles based on selected sources
- Save / unsave articles
- Open articles in an in-app WebView
- Graceful empty states

### Sources Tab
- Lists English-only news sources
- Multi-select support
- Selection persists across launches

### Saved Tab
- Shows saved articles
- Supports delete
- Changes reflect instantly across tabs

---

