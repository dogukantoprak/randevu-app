# Randevu App (Flutter + Firebase)

A modern, full-stack appointment and reservation system built with Flutter and Firebase. Designed for both Business Owners (Service Providers) and Customers.

## 🚀 Features

### Authentication & Roles
- **Secure Authentication:** Powered by Firebase Auth.
- **Role-Based Access Control:** Separate flows for `Customer` and `Business Owner`.
- **Persistent Login:** Auto-login functionality with secure token management.

### For Business Owners
- **Service Management:** Create, edit, and delete services (e.g., Haircut, Spa).
- **Appointment Dashboard:** View upcoming appointments in a calendar view.
- **Revenue Tracking:** Simple analytics for completed services.

### For Customers
- **Service Discovery:** Browse available services with details (price, duration).
- **Booking System:** Easy appointment scheduling with date & time selection.
- **My Appointments:** Track status (Pending, Confirmed, Cancelled) of bookings.

## 🛠 Tech Stack

- **Framework:** Flutter (Mobile First Design)
- **Backend:** Firebase (Auth, Firestore)
- **State Management:** Riverpod (Clean Architecture)
- **Routing:** GoRouter
- **Networking:** Dio
- **Storage:** Flutter Secure Storage
- **UI:** Material 3 Design System

## 📦 Setup & Installation

This project is configured for **Web** out-of-the-box for demonstration purposes.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/dogukantoprak/randevu-app.git
    cd randevu-app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app (Web):**
    ```bash
    flutter run -d chrome
    ```

> **Note:** For Android/iOS deployment, you will need to configure your own Firebase project using `flutterfire configure` to generate `google-services.json` and `GoogleService-Info.plist` files.

## 📸 Screenshots

*(Screenshots to be added)*

## 📄 License

This project is open-source and available under the content of the MIT License.

---
*Developed by Doğukan Toprak*
