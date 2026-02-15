# 📅 Randevu App
**Your all-in-one appointment and reservation management system.**

Features • Tech Stack • Architecture • Getting Started • Project Structure • Contributing

## 📖 Overview
**Randevu App** is a modern, cross-platform application built with **Flutter** that connects service providers (Business Owners) with customers. It streamlines the booking process by allowing customers to discover services and schedule appointments, while giving business owners tools to manage their offerings and calendar—all in real-time.

## ✨ Features
| Feature | Description |
| :--- | :--- |
| **🔐 Authentication** | Secure Email/Password registration and login powered by **Firebase Auth**. |
| **👥 Role-Based Access** | Distinct experiences for **Customers** and **Business Owners** within a single app. |
| **📅 Smart Booking** | Interactive date & time picker for scheduling appointments effortlessly. |
| **🛠 Service Management** | Owners can create, edit, and delete services (e.g., Haircut, Spa) with custom icons. |
| **⚡ Real-time Updates** | Instant synchronization of appointments and services using **Cloud Firestore streams**. |
| **📱 Responsive UI** | Built with **Material 3 Design**, ensuring a beautiful experience on Web and Mobile. |
| **📊 Dashboard** | Owners view incoming appointments; Customers track booking status (Pending/Confirmed). |

## 🛠 Tech Stack
| Layer | Technology |
| :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart) |
| **State Management** | [Riverpod](https://riverpod.dev) (Code Generation) |
| **Backend (Auth)** | [Firebase Authentication](https://firebase.google.com/docs/auth) |
| **Backend (DB)** | [Cloud Firestore](https://firebase.google.com/docs/firestore) |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) (Strongly-typed routes) |
| **Secure Storage** | [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) |
| **Networking** | [Dio](https://pub.dev/packages/dio) (HTTP Client) |
| **UI Kit** | Material 3 (FlexColorScheme) |

## 🏗 Architecture
The project follows a **Feature-First Clean Architecture**, ensuring scalability and testability.

```ascii
┌─────────────────────────────────────┐
│          Presentation Layer         │
│   Screens (UI), Widgets, Providers  │
│   (Consumes Application Services)   │
├─────────────────────────────────────┤
│          Application Layer          │
│      Controllers / Notifiers        │
│    (Business Logic Orchestration)   │
├─────────────────────────────────────┤
│             Domain Layer            │
│      Entities (Models), Repos,      │
│         Business Rules              │
├─────────────────────────────────────┤
│              Data Layer             │
│    Repository Implementations,      │
│    Data Sources (Firestore API)     │
└─────────────────────────────────────┘
```

- **Feature-First:** Code is organized by feature (`auth`, `customer`, `owner`) rather than by layer.
- **Repository Pattern:** Abstracts data sources (Firestore) from the UI logic.
- **Stream-Based:** UI reacts to data changes in real-time via Riverpod providers.

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or higher)
- A browser (Chrome/Edge) for Web debugging
- An IDE (VS Code or Android Studio)

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/dogukantoprak/randevu-app.git
    cd randevu-app
    ```

2.  **Install dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the app (Web)**
    ```bash
    flutter run -d chrome
    ```
    *(The project includes a web configuration for immediate testing)*

### Firebase Configuration
For Production or Native (Android/iOS) builds:
1.  Create a project in [Firebase Console](https://console.firebase.google.com).
2.  Enable **Authentication** and **Cloud Firestore**.
3.  Run `flutterfire configure` to generate platform-specific configuration.

## 📁 Project Structure
```
lib/
├── core/                   # Global utilities, theme, router, network clients
│   ├── config/             # App environment config
│   ├── network/            # Dio client setup
│   ├── router/             # GoRouter configuration
│   └── theme/              # App theme & colors
├── features/               # Feature modules
│   ├── auth/               # Authentication feature
│   │   ├── application/    # Logic (AuthController)
│   │   ├── data/           # Repos (AuthRepository, Firestore implementations)
│   │   ├── domain/         # Models (UserProfile, UserRole)
│   │   └── presentation/   # Screens (Login, Register)
│   ├── customer/           # Customer-specific features
│   │   ├── presentation/   # Screens (Services, Appointments, Profile)
│   │   └── ...
│   └── owner/              # Owner-specific features
│       ├── presentation/   # Screens (Admin Panel, Calendar)
│       └── ...
├── app.dart                # Main App Widget
├── firebase_options.dart   # Firebase Config (Generated)
└── main.dart               # Entry point
```

## 🤝 Contributing
Contributions are welcome! Please follow these steps:
1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feature/amazing-feature`).
3.  Commit your changes (`git commit -m 'Add amazing feature'`).
4.  Push to the branch (`git push origin feature/amazing-feature`).
5.  Open a Pull Request.

## 📄 License
This project is open-source and available under the content of the MIT License.

---
*Developed by Doğukan Toprak*
