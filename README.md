# 📰 News IQ - institutional News Intelligence

**A scalable, cross-platform business intelligence application following Clean Architecture principles.**

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-blue?logo=flutter)](https://flutter.dev)
[![Riverpod](https://img.shields.io/badge/State%20Management-Riverpod-00B0FF)](https://riverpod.dev)
[![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-9cf)](https://flutter.dev/multi-platform)

---

## 🎯 Project Highlights

✅ **Clean Architecture**: Strict separation of concerns (Core, Features, Data, Presentation).  
✅ **Riverpod State Management**: High-performance, compile-safe state handling using Notifiers.  
✅ **Offline Intelligence**: Full offline persistence for favorites via Hive NoSQL database.  
✅ **Institutional UI**: Modern dark-themed design with Glassmorphism and Shimmer effects.  
✅ **Robust Networking**: Centralized Dio client with interceptors for automated API security.

---

## 📱 Feature Showcase

| Feature | Implementation Details |
|---------|----------------------|
| **Real-time News Feed** | Category-based filtering with infinite scrolling pagination. |
| **Advanced Search** | Real-time API-driven search with interactive suggestion chips. |
| **Offline Favorites** | persistent local storage using Hive for seamless offline reading. |
| **Auth Persistence** | remembers user session state to bypass login on restart. |
| **Institutional Detail** | Full article previews with external source launching via `url_launcher`. |

---

## 🏗️ Technical Architecture

```mermaid
graph TD
    A[Presentation Layer] -->|Ref / Watch| B[Riverpod Layer]
    B -->|States (AsyncValue)| A
    B -->|Repository Calls| D[Data Layer]
    D -->|Network Client| E[Dio / News API]
    D -->|Local Persistence| F[Hive Database]
```

### Key Architectural Decisions:
1. **Riverpod Pattern** for high-performance, compile-safe state management.
2. **Clean Architecture**: Strict separation between presentation, data, and core layers.
3. **Dio Networking**: Advanced API handling with interceptors for security and performance.
4. **Offline-First**: robust local caching and favorites management via Hive NoSQL.
5. **Modern Theming**: Premium institutional dark-mode UI with Google Fonts integration.

---

## 🛠️ Tech Stack & Packages

| Package             | Usage                                      | Version    |
|---------------------|--------------------------------------------|------------|
| `flutter_riverpod`  | Reactive state management & dependency injection | ^2.5.1     |
| `dio`               | Advanced REST API client with interceptors  | ^5.4.0     |
| `hive_flutter`      | Ultra-fast NoSQL local database             | ^1.1.0     |
| `shimmer`           | Smooth skeleton loaders for data fetching   | ^3.0.0     |
| `url_launcher`      | External browser integration for full articles | ^6.3.2     |
| `google_fonts`      | Premium typography for market intelligence | ^8.0.2     |

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0+
- News API Key (from newsapi.org)

### Quick Start
```bash
# 1. Clone repository
git clone https://github.com/cybersleuth0/NewsApp.git

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

---

## 📂 Project Structure

```text
lib/
├── core/                   # Shared utilities, constants, & network logic
│   ├── network/            # Dio configuration & interceptors
│   ├── utils/              # Hive persistence helpers
│   └── constants/          # API & App configurations
├── features/               # Domain-specific logic
│   ├── auth/               # Login logic & session persistence
│   └── news/               # Feed, Search, Favorites, & Detail screens
└── main.dart               # App entry point & Hive initialization
```

---

