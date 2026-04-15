# 🍳 FridgeChef

> **Cook what you already have.** FridgeChef flips the recipe discovery experience — you tell it what's in your fridge, it tells you what you can make.

A Flutter mobile app (iOS & Android) that matches your available ingredients to recipes, sorted by fewest missing items. Built with MongoDB Atlas as the primary database and Firebase Firestore as a fallback.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Database Setup](#database-setup)
- [Project Structure](#project-structure)
- [Screens](#screens)
- [Development Team](#development-team)

---

## Features

- **Pantry grid** — tap ingredients to mark what you have; searchable 3-column grid with emoji icons
- **Recipe matching** — instant results sorted by fewest missing ingredients, all computed on-device
- **Veg / Non-veg filter** — toggle between All, Veg only, or Non-veg only recipes on the recipes screen
- **Cuisine & cookability filters** — filter chips for cuisine type and a "Cookable Now" toggle
- **Recipe detail** — green tick / red X per ingredient, step-by-step instructions, cook time, servings, difficulty
- **Shopping list** — add missing ingredients from any recipe; check off items, swipe to delete
- **Saved recipes** — bookmark favourites for quick access; persisted across sessions
- **Offline-friendly** — database fetched once at launch and cached in memory; all matching runs locally

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile framework | Flutter (iOS & Android) |
| Primary database | MongoDB Atlas (cloud NoSQL) |
| Fallback database | Firebase Firestore |
| Local persistence | shared_preferences |
| State management | setState() + Provider pattern |
| Auth (optional) | Firebase Anonymous Auth |

---

## Architecture

FridgeChef uses a two-tier architecture: a Flutter client and a cloud backend.

```
┌─────────────────────────────────────┐
│           Flutter App               │
│  Presentation  →  State / Logic     │
│       ↓                             │
│  DatabaseService (fetch once)       │
│       ↓                             │
│  In-memory cache  →  RecipeMatcher  │
│       ↓                             │
│  shared_preferences (user state)    │
└─────────────────────────────────────┘
         ↕ (launch only)
┌─────────────────────────────────────┐
│  MongoDB Atlas  (primary)           │
│  Firebase Firestore  (fallback)     │
└─────────────────────────────────────┘
```

- Recipe and ingredient data is fetched **once per session** at launch and held in memory.
- All matching, sorting, and filtering (including the veg/non-veg toggle) runs **locally** — no network calls after startup.
- User state (pantry, bookmarks, shopping list) is stored **on-device only** via `shared_preferences`.

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart `>=3.0.0`
- A MongoDB Atlas account **or** a Firebase project (see [Database Setup](#database-setup))
- Android Studio / Xcode for device emulation

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/your-org/fridgechef.git
cd fridgechef

# 2. Install dependencies
flutter pub get

# 3. Configure your database (see Database Setup below)

# 4. Run the app
flutter run
```

### Build

```bash
# Android release APK
flutter build apk --release

# iOS release
flutter build ios --release
```

---

## Database Setup

### Option A — MongoDB Atlas (Primary)

1. Create a free **M0 cluster** at [cloud.mongodb.com](https://cloud.mongodb.com).
2. Create a database named `fridgechef` with two collections: `ingredients` and `recipes`.
3. Add your connection string to `lib/services/database_config.dart`:
   ```dart
   const mongoUri = 'mongodb+srv://<user>:<password>@cluster0.mongodb.net/fridgechef';
   ```
4. Add the `mongo_dart` package to `pubspec.yaml`:
   ```yaml
   mongo_dart: ^0.9.x
   ```
5. Seed the collections (40–50 ingredients, 25–30 recipes) using the schema below.

### Option B — Firebase Firestore (Fallback)

1. Create a project at [console.firebase.google.com](https://console.firebase.google.com).
2. Enable Firestore in production mode and apply the security rules:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /ingredients/{doc} { allow read: if true; allow write: if false; }
       match /recipes/{doc}     { allow read: if true; allow write: if false; }
     }
   }
   ```
3. Run `flutterfire configure` and commit the generated `lib/firebase_options.dart`.
4. Seed via the Firebase Console or a one-time `bin/seed.dart` script.

---

## Data Schema

### `ingredients` collection

| Field | Type | Description |
|---|---|---|
| id | string | Unique slug, e.g. `"tomato"` |
| name | string | Display name, e.g. `"Tomato"` |
| category | string | `Dairy`, `Vegetable`, `Protein`, `Pantry`, or `Spice` |
| emoji | string | Single emoji icon, e.g. `"🍅"` |

### `recipes` collection

| Field | Type | Description |
|---|---|---|
| id | string | Unique slug, e.g. `"pasta_aglio"` |
| name | string | Display name |
| ingredients | array\<string\> | List of ingredient slugs |
| steps | array\<string\> | Ordered cooking instructions |
| cookTime | number | Minutes |
| servings | number | Number of servings |
| cuisine | string | e.g. `Italian`, `Asian`, `Indian` |
| difficulty | string | `Easy`, `Medium`, or `Hard` |
| isVeg | boolean | `true` = fully vegetarian; `false` = contains meat/poultry/seafood |

---

## Project Structure

```
lib/
├── main.dart                    # App entry, routes, Firebase.initializeApp(), theme
├── models/
│   ├── ingredient.dart          # Ingredient data class
│   └── recipe.dart              # Recipe data class
├── services/
│   ├── database_service.dart    # MongoDB / Firestore fetch logic (fetchIngredients, fetchRecipes, initAndCache)
│   ├── pantry_service.dart      # shared_preferences read/write for pantry state
│   └── saved_service.dart       # shared_preferences read/write for bookmarks
├── logic/
│   └── matcher.dart             # RecipeMatcher.match() and getMissing() — pure Dart, no I/O
├── screens/
│   ├── pantry_screen.dart       # Screen 1 — ingredient grid
│   ├── recipes_screen.dart      # Screen 2 — matched recipes + veg filter
│   ├── recipe_detail_screen.dart# Screen 3 — full recipe view
│   ├── shopping_screen.dart     # Screen 4 — shopping checklist
│   └── saved_screen.dart        # Screen 5 — bookmarked recipes
└── widgets/
    ├── ingredient_card.dart
    ├── recipe_card.dart
    └── badge.dart
```

---

## Screens

| # | Screen | Route | Owner |
|---|---|---|---|
| 1 | Pantry (Home) | `/pantry` | Person 2 |
| 2 | Recipe Matches | `/recipes` | Person 3 |
| 3 | Recipe Detail | `/recipe/:id` | Person 4 |
| 4 | Shopping List | `/shopping` | Person 5 |
| 5 | Saved Recipes | `/saved` | Person 5 |

Navigation uses a bottom bar with three tabs (Pantry, Saved, Shopping). The Recipes and Recipe Detail screens are pushed modally on top of the Pantry tab.

---

## Performance Targets

| Metric | Target |
|---|---|
| Cold start to usable UI | < 3 seconds |
| Database fetch latency | < 1.5 seconds |
| Ingredient toggle latency | < 50 ms |
| Recipe list scroll | 60 fps |
| Memory footprint | < 100 MB |
| APK size | < 25 MB |

---

## Development Team

| Member | Responsibility |
|---|---|
| Person 1 | Database setup, data layer, models, services, app wiring |
| Person 2 | Pantry screen |
| Person 3 | Recipes screen (incl. veg/non-veg toggle) |
| Person 4 | Recipe detail screen |
| Person 5 | Shopping list + Saved recipes + bottom navigation |

---

## License

For academic use only — FridgeChef v2.0.
