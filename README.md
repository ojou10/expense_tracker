```markdown
# 💸 Expense Tracker App

A professional-grade, offline-first mobile application built with **Flutter** and **Firebase**. This app provides a seamless way to track daily spending, manage receipts via native camera integration, and visualize financial habits through dynamic charts.

## ✨ Key Features

* **🔐 Secure Authentication:** User registration and login powered by Firebase Authentication, with unique data isolation per user.
* **📱 Offline-First Architecture:** Full functionality without an internet connection using `SharedPreferences` for local caching, syncing automatically to Cloud Firestore when online.
* **📸 Native Receipt Capture:** Integrated device camera functionality to photograph and attach physical receipts to specific expense entries.
* **📊 Dynamic Visualizations:** Interactive Pie Charts for category-based spending analysis using the `fl_chart` library.
* **🎨 Custom UI & Personalization:** Features a custom-built, reusable `CategoryBadge` widget for consistent styling, plus persistent Dark Mode and customizable user profiles.

## 🛠️ Tech Stack

* **Frontend:** Flutter & Dart
* **Backend:** Firebase (Authentication & Cloud Firestore)
* **State Management:** Provider
* **Local Storage:** SharedPreferences
* **Key Packages:** `fl_chart`, `camera`, `http`

## 🚀 Getting Started

### Prerequisites
* Flutter SDK installed on your local machine.
* A Firebase Project configured for this application.

### Installation & Setup
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/ojou10/expense_tracker.git](https://github.com/ojou10/expense_tracker.git)

```

2. **Navigate to the project directory:**
```bash
cd expense_tracker

```


3. **Install dependencies:**
```bash
flutter pub get

```


4. **Set up Firebase:**
* Create a project in the [Firebase Console](https://console.firebase.google.com/).
* Register your app and download the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) files into their respective directories.
* Enable **Email/Password Authentication** and **Cloud Firestore**.


5. **Run the application:**
```bash
flutter run

```

