# 📅 Randevu App

> Scalable appointment booking system foundation built with Flutter.

A mobile-first appointment & reservation system supporting **two user roles** — Customers who book services and Business Owners who manage their business — with clean architecture, role-based routing, and Material 3 design.

---

## Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **State Management** | Riverpod (`flutter_riverpod`) |
| **Routing** | GoRouter (`go_router`) |
| **Networking** | Dio (`dio`) |
| **Secure Storage** | `flutter_secure_storage` |
| **UI** | Material 3 (Material You) |
| **Architecture** | Feature-first Clean Architecture |

---

## Architecture

The project follows a **feature-first clean architecture** pattern, separating concerns into domain, application, and presentation layers per feature module.

```
lib/
├── main.dart                          # App entry point with ProviderScope
├── app.dart                           # MaterialApp.router setup
│
├── core/                              # Shared infrastructure
│   ├── config/
│   │   └── app_config.dart            # API base URL, app constants
│   ├── network/
│   │   ├── dio_provider.dart          # Dio instance with interceptors
│   │   └── api_client.dart            # Centralized HTTP client (GET/POST)
│   ├── router/
│   │   └── router_provider.dart       # GoRouter with auth-aware redirects
│   ├── storage/
│   │   └── secure_storage_provider.dart  # FlutterSecureStorage provider
│   └── theme/
│       └── app_theme.dart             # Material 3 light & dark themes
│
├── features/
│   ├── auth/                          # Authentication feature
│   │   ├── domain/
│   │   │   └── user_role.dart         # UserRole enum (customer, owner)
│   │   ├── application/
│   │   │   └── auth_controller.dart   # AuthState + AuthController (StateNotifier)
│   │   └── presentation/
│   │       ├── login_screen.dart      # Login form with validation
│   │       ├── register_screen.dart   # Registration with password confirmation
│   │       └── role_choose_screen.dart # Post-login role selection
│   │
│   ├── customer/                      # Customer-facing feature
│   │   └── presentation/
│   │       ├── customer_home.dart     # Bottom nav (Services, Appointments, Profile)
│   │       ├── services_screen.dart   # Service listing with booking buttons
│   │       ├── my_appointments_screen.dart  # Appointment history (placeholder)
│   │       └── customer_profile_screen.dart # Profile & logout
│   │
│   └── owner/                         # Business Owner feature
│       └── presentation/
│           ├── owner_home.dart        # Bottom nav (Calendar, Services, Settings)
│           ├── owner_calendar_screen.dart      # Daily bookings view (placeholder)
│           ├── owner_services_admin_screen.dart # Service CRUD management
│           └── owner_settings_screen.dart      # Business settings & logout
```

---

## Implemented Features

### ✅ Authentication
- Login screen with email/password and loading states
- Registration screen with password confirmation
- Secure token persistence via `flutter_secure_storage`
- Error handling with snackbar feedback
- Logout with full state reset

### ✅ Role-Based System
- Post-login role selection (Customer / Business Owner)
- Role persistence across sessions
- Route guards: prevents cross-role navigation
- Automatic redirect based on auth + role state

### ✅ Customer Flow
- Bottom navigation: **Services**, **Appointments**, **Profile**
- Service listing UI with booking buttons
- Profile screen with settings and logout

### ✅ Business Owner Flow
- Bottom navigation: **Calendar**, **Services**, **Settings**
- Calendar view for daily bookings
- Service management with add/edit UI
- Business settings with staff and hours sections

### ✅ Core Infrastructure
- Material 3 theming (light + dark mode)
- Dio HTTP client with configurable base URL, timeouts, and log interceptor
- GoRouter with auth-aware redirect logic
- Riverpod for dependency injection and state management
- Centralized API client ready for backend integration

---

## 🗺️ Roadmap

Planned features for upcoming releases:

- 🔗 Backend API integration (REST / Firebase / Supabase)
- 📆 Interactive appointment calendar with date & time picker
- 🔔 Push notifications via Firebase Cloud Messaging
- 🔍 Service search and filtering
- 💳 In-app payment integration
- 📊 Business analytics dashboard
- 🌍 Multi-language support (TR / EN)
- 🧪 Unit and widget test coverage

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, ≥ 3.2.0)
- Android Studio / VS Code with Flutter extension
- Chrome (for web) or Android emulator / physical device

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/dogukantoprak/randevu-app.git
cd randevu-app

# 2. Install dependencies
flutter pub get

# 3. Generate platform files (if missing)
flutter create .
```

### Run on Web

```bash
flutter run -d chrome
```

### Run on Android

```bash
# With connected device or emulator
flutter run -d android
```

### Run on iOS (macOS only)

```bash
flutter run -d ios
```

---

## License

This project is for educational and portfolio purposes.

---

<p align="center">
  Built with ❤️ using Flutter & Dart
</p>
