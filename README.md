# Expense Tracker

A Flutter-based mobile application for tracking personal expenses with receipt photo capture, currency conversion, and cloud synchronization.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Problem Statement](#problem-statement)
3. [Objectives](#objectives)
4. [Features](#features)
5. [Project Design](#project-design)
   - [Use Case Diagram](#use-case-diagram)
   - [Class Diagram](#class-diagram)
   - [Components Used](#components-used)
6. [Tech Stack](#tech-stack)
7. [Screenshots](#screenshots)
8. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
   - [Firebase Setup](#firebase-setup)
9. [Project Structure](#project-structure)
10. [Conclusion](#conclusion)
11. [References](#references)

---

## Introduction

Expense Tracker is a cross-platform mobile application built with Flutter that helps users monitor and manage their daily expenses. Users can log expenses by category, view spending analytics through interactive charts, capture receipt photos using the device camera, and sync their data securely to the cloud via Firebase Firestore.

The application was developed as part of the CBSD (Component-Based Software Development) 2026 curriculum, demonstrating proficiency in Flutter framework, Firebase backend integration, REST APIs, native device features, state management, and component-based architecture.

---

## Problem Statement

Managing personal finances is a common challenge for students and professionals alike. Many individuals struggle to track where their money goes each month, leading to overspending and poor financial planning. Existing solutions are either too complex, require subscriptions, or lack offline support. There is a need for a simple, intuitive, and free expense tracking application that:

- Allows quick logging of expenses on the go
- Provides visual spending breakdowns by category
- Supports receipt capture for record-keeping
- Synchronizes data securely across devices
- Works offline with local storage fallback

---

## Objectives

1. **Simplify Expense Tracking**: Provide an intuitive interface to log expenses with minimal friction
2. **Visual Analytics**: Display spending patterns through pie charts for better financial awareness
3. **Receipt Management**: Enable users to capture and associate receipt photos with expenses
4. **Secure Authentication**: Implement email/password authentication using Firebase Auth
5. **Cloud Synchronization**: Store expense data in Firestore for cross-device access and backup
6. **Offline Support**: Maintain local storage via SharedPreferences as a fallback when offline
7. **Custom Reusable Components**: Develop and integrate custom Flutter widgets following CBSD principles
8. **Native Feature Integration**: Leverage device camera for receipt photo capture
9. **API Integration**: Fetch live currency exchange rates for multi-currency support
10. **Theme Support**: Provide light and dark mode with persistent user preferences

---

## Features

- **Authentication**: Sign up / Sign in with email and password (Firebase Auth)
- **Dashboard**: View total spending, toggle USD/EGP currency, and analyze category breakdowns via pie chart
- **Add Expense**: Log expenses with title, amount, category, and optional receipt photo
- **Expense History**: Browse past transactions with category badges and formatted dates
- **Receipt Capture**: Take photos of receipts using the device camera with permission handling
- **Profile Management**: Update display name, toggle dark mode, and sign out
- **Cloud Sync**: Expenses stored in Firestore for multi-device access
- **Offline Mode**: Local SharedPreferences cache ensures data availability without internet

---

## Project Design

### Use Case Diagram

```
┌─────────────────────────────────────────────────────┐
│                   Expense Tracker                    │
│                                                     │
│  ┌──────────┐                                       │
│  │   User   │                                       │
│  └────┬─────┘                                       │
│       │                                             │
│       ├── Register / Login ────── Firebase Auth     │
│       ├── View Dashboard ──────── PieChart + API    │
│       ├── Add Expense ──────────── Local + Firestore│
│       ├── Capture Receipt ──────── Device Camera    │
│       ├── View History ─────────── Expense List     │
│       ├── Manage Profile ──────── Name + Theme      │
│       └── Logout ───────────────── Clear Session    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

### Class Diagram

```
┌──────────────────┐       ┌─────────────────────┐
│     Expense      │       │   ExpenseProvider    │
├──────────────────┤       ├─────────────────────┤
│ + id: String     │       │ - _expenses: List    │
│ + title: String  │       │ - _firestore: Fire.. │
│ + amount: double │       │ - _userId: String    │
│ + date: DateTime │       ├─────────────────────┤
│ + category: Str  │       │ + loadExpenses()     │
│ + userId: String?│       │ + addExpense()       │
├──────────────────┤       │ + deleteExpense()    │
│ + toJson()       │       │ + clearExpenses()    │
│ + fromJson()     │       │ - _loadFromLocal()   │
└──────────────────┘       │ - _saveToLocal()     │
                           └─────────────────────┘
                                    │
                           uses Provider pattern
                                    │
┌──────────────────┐       ┌─────────────────────┐
│  ThemeProvider   │       │    ApiService        │
├──────────────────┤       ├─────────────────────┤
│ - _isDarkMode    │       │ + fetchExchangeRate()│
├──────────────────┤       │   (static method)    │
│ + toggleTheme()  │       └─────────────────────┘
└──────────────────┘                │
                           calls open.er-api.com
```

### Components Used

| Component | Type | Source | Purpose |
|-----------|------|--------|---------|
| `PieChart` (fl_chart) | Third-party | pub.dev | Spending breakdown visualization |
| `CategoryBadge` | **Custom** (self-made) | `lib/widgets/` | Reusable colored category pill |
| `CameraPreview` (camera) | Platform plugin | pub.dev | Receipt photo capture |
| `FirebaseAuth` | Backend service | Firebase | Email/password authentication |
| `Firestore` | Backend service | Firebase | Cloud expense storage |
| `SharedPreferences` | Platform plugin | pub.dev | Local key-value persistence |
| `Provider` | State management | pub.dev | Reactive state propagation |
| `http` | Network | pub.dev | REST API calls |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.x (Dart) |
| **State Management** | Provider + ChangeNotifier |
| **Authentication** | Firebase Auth (email/password) |
| **Cloud Database** | Cloud Firestore |
| **Local Storage** | SharedPreferences |
| **Charts** | fl_chart |
| **Camera** | camera + permission_handler |
| **HTTP Client** | http |
| **Fonts** | Poppins (Google Fonts) |
| **Platform** | Android, iOS, Web, Windows, macOS, Linux |

---

## Screenshots

> _Add screenshots here showing: Login screen, Dashboard with pie chart, Add Expense form, Expense History list, Camera receipt capture, and Profile screen._

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.3.0
- Dart SDK >= 3.3.0
- Android Studio / VS Code
- Firebase project (for authentication and Firestore)

### Installation

```bash
# Clone the repository
git clone https://github.com/ojou10/expense_tracker.git
cd expense_tracker

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Firebase Setup

1. Create a project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Authentication** → Email/Password sign-in method
3. Enable **Cloud Firestore** in production mode
4. Download `google-services.json` and place it in `android/app/`
5. Download `GoogleService-Info.plist` and place it in `ios/Runner/` (for iOS)

**Firestore Security Rules** (recommended):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /expenses/{expenseId} {
      allow read: if request.auth != null
                  && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null
                    && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null
                            && resource.data.userId == request.auth.uid;
    }
  }
}
```

---

## Project Structure

```
lib/
├── main.dart                     # App entry, Firebase init, routing, theme
├── models/
│   └── expense.dart              # Expense data model with JSON serialization
├── screens/
│   ├── login_screen.dart         # Firebase email/password authentication
│   ├── dashboard_screen.dart     # Total spending + pie chart + currency API
│   ├── add_expense_screen.dart   # Expense creation form + camera launcher
│   ├── history_screen.dart       # Expense list with category badges
│   ├── camera_screen.dart        # Receipt photo capture with permissions
│   └── profile_screen.dart       # User name, dark mode toggle, logout
├── services/
│   ├── expense_provider.dart     # CRUD + Firestore sync + local cache
│   ├── theme_provider.dart       # Dark mode state persistence
│   └── api_service.dart          # REST API for currency exchange rates
└── widgets/
    └── category_badge.dart       # Custom reusable category badge component
```

---

## Conclusion

The Expense Tracker application successfully demonstrates the core principles of Component-Based Software Development. By leveraging Flutter's widget-based architecture, the project integrates third-party components (`fl_chart`, `camera`, `firebase_auth`), a custom-built reusable component (`CategoryBadge`), multiple platform plugins, and cloud APIs into a cohesive mobile application.

Key CBSD requirements fulfilled include:
- Authentication via Firebase Auth
- Native camera feature integration with permission handling
- Tab-based navigation across 6 screens
- Combination of Stateful and Stateless widgets
- Custom fonts and image assets
- Local storage (SharedPreferences) and cloud storage (Firestore)
- REST API integration for currency conversion
- Use of an internet-sourced custom component (`fl_chart` PieChart)
- Creation of a custom reusable widget (`CategoryBadge`)

The application provides a practical, real-world solution for personal expense management while showcasing modern Flutter development practices.

---

## References

1. **Flutter Documentation** — https://flutter.dev/docs
2. **Firebase FlutterFire** — https://firebase.flutter.dev/
3. **Cloud Firestore** — https://firebase.google.com/docs/firestore
4. **Firebase Authentication** — https://firebase.google.com/docs/auth
5. **fl_chart Package** — https://pub.dev/packages/fl_chart
6. **camera Package** — https://pub.dev/packages/camera
7. **permission_handler Package** — https://pub.dev/packages/permission_handler
8. **Provider Package** — https://pub.dev/packages/provider
9. **SharedPreferences** — https://pub.dev/packages/shared_preferences
10. **Open Exchange Rates API** — https://open.er-api.com/
11. **Dart Language Tour** — https://dart.dev/guides/language/language-tour
12. **Material Design 3** — https://m3.material.io/
