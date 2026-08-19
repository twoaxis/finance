# AGENTS.md

> Guidelines for AI coding agents working on this repository.

## Project Overview

TwoAxis Finance is a personal finance management app with three deployable surfaces sharing a single Firebase backend:

| Surface | Directory | Stack |
|---------|-----------|-------|
| Mobile app (primary) | `mobile/` | Flutter/Dart, BLoC pattern |
| Web app | `web/` | React 19, TypeScript, Vite, Tailwind CSS v4 |
| Marketing website | `website/` | Static HTML/CSS (no build step) |

Firebase project: `financial-planner-72109` (package: `org.twoaxis.finance`).

---

## Repository Structure

```
├── mobile/                  # Flutter mobile app (Android)
│   ├── lib/
│   │   ├── app/             # App root, theme, theme cubit
│   │   ├── core/            # Shared abstracts, services, utilities, widgets, failures
│   │   └── features/        # Feature modules (20 total)
│   ├── assets/              # Images and Lottie animations
│   ├── android/             # Android-specific build config (Gradle KTS)
│   └── pubspec.yaml
├── web/                     # React web app
│   ├── src/
│   │   ├── components/      # Reusable UI components
│   │   ├── contexts/        # React Context providers (Auth, UserData, Theme)
│   │   ├── hooks/           # Custom hooks (useTransactions)
│   │   ├── pages/           # Route page components
│   │   ├── types/           # TypeScript interfaces
│   │   ├── utils/           # Constants, categories, formatters
│   │   ├── firebase.ts      # Firebase init + emulator connection
│   │   ├── App.tsx          # Root component with routing
│   │   └── main.tsx         # Entry point
│   ├── public/              # Static assets (images, icons)
│   └── package.json
├── website/                 # Static marketing site
│   ├── index.html, privacy.html, terms.html, delete.html, 404.html
│   ├── style.css
│   └── img/
├── docs/                    # Domain concept documentation
├── firebase.json            # Firebase services config (Hosting, Firestore, Emulators)
├── firestore.rules          # Firestore security rules
├── firestore.indexes.json   # Firestore composite indexes (currently empty)
└── .github/workflows/       # CI/CD pipelines
```

---

## Technology Stack

### Mobile (`mobile/`)
- **Language**: Dart (SDK `^3.5.3`)
- **Framework**: Flutter (stable channel, `3.38.5` in CI)
- **State management**: `flutter_bloc` (BLoC + Cubit pattern)
- **Firebase SDKs**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_analytics`, `firebase_messaging`
- **Key libraries**: `fl_chart`, `lottie`, `google_sign_in`, `intl`, `rxdart`, `equatable`, `shared_preferences`, `url_launcher`, `package_info_plus`
- **Android**: minSdk 24, compileSdk/targetSdk 37, Gradle Kotlin DSL, Java 1.8

### Web (`web/`)
- **Language**: TypeScript (`~6.0`)
- **Framework**: React 19 with `react-router-dom` v7
- **Build tool**: Vite 8
- **Styling**: Tailwind CSS v4 (via `@tailwindcss/vite` plugin)
- **Linter**: OxLint (with `react`, `typescript`, `oxc` plugins)
- **Firebase SDK**: `firebase` v12 (web modular API)
- **Charts**: `chart.js` + `react-chartjs-2`
- **Font**: Sen (Google Fonts), Material Symbols Outlined (icons)

### Website (`website/`)
- Plain HTML + vanilla CSS. No framework, no build step.

### Backend
- **Database**: Cloud Firestore (no custom indexes defined)
- **Authentication**: Firebase Auth (email/password + Google Sign-In)
- **Hosting**: Firebase Hosting with two targets (`website` → static site, `web` → SPA with catch-all rewrite)
- **Notifications**: Firebase Cloud Messaging (mobile only)

---

## Architecture Patterns

### Mobile — Clean Architecture + BLoC

Each feature module in `mobile/lib/features/` follows this structure:

```
features/<name>/
├── data/                    # Repository implementations (Firestore queries)
├── domain/                  # Abstract repositories, models/entities, failure types
└── presentation/
    ├── bloc/ or cubit/      # BLoC/Cubit + Event + State classes
    ├── pages/               # Full-screen page widgets
    └── widgets/             # Feature-specific reusable widgets
```

- All BLoCs and repositories are injected at the app root via `MultiBlocProvider` and `MultiRepositoryProvider` in `lib/app/app.dart`.
- Auth state is observed via `FirebaseAuth.authStateChanges()` stream — when authenticated, all feature BLoCs are created with the current `userId`.
- Theme is managed by `ThemeCubit` (persisted in `SharedPreferences`; defaults to dark mode).
- Shared base classes live in `lib/core/`:
  - `core/abstract/` — abstract interfaces (e.g. `NotificationService`)
  - `core/services/` — service implementations
  - `core/values/` — constants (categories, currencies, spacing)
  - `core/util/` — helper functions (money formatting, category icon lookup)
  - `core/widgets/` — shared UI widgets (`PrimaryButton`, `ThemedInputField`)
  - `core/failures/` — error types (`ServerFailure`, `ConnectionFailure`, `InvalidEmailFailure`)

### Web — React Context + Hooks

- **State management**: React Context API with real-time Firestore `onSnapshot` listeners.
  - `AuthContext` — Firebase Auth state (`currentUser`, `loading`), exposes `login`, `signup`, `logout`, `resetPassword`.
  - `UserDataContext` — real-time user document from `users/{uid}`, exposes CRUD helpers for each data array.
  - `ThemeContext` — light/dark toggle persisted in `localStorage`.
- **Custom hooks**: `useTransactions` — real-time transactions subcollection listener with add/delete.
- **Routing**: `react-router-dom` with `ProtectedRoute` / `PublicRoute` wrappers. Protected routes are wrapped in `AppLayout` (sidebar + content area).
- **Component hierarchy**: `BrowserRouter → ThemeProvider → AuthProvider → Routes → (ProtectedRoute → UserDataProvider → AppLayout → Page)`.

---

## Firestore Data Model

All user data is scoped under `users/{userId}/`:

```
users/{userId}                           # User profile (currency, budget, name, photoUrl)
users/{userId}/transactions/{txId}       # Transaction records
users/{userId}/bills/{billId}            # Recurring bills
users/{userId}/income/{incomeId}         # Income sources
users/{userId}/balances/{balanceId}      # Account balances
users/{userId}/assets/{assetId}          # Assets
users/{userId}/receivables/{recId}       # Money owed to user
users/{userId}/liabilities/{liabId}      # Money user owes
```

### Security Rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{documentId=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Rule**: Only authenticated users can read/write their own data. All documents under `users/{userId}` (including all subcollections) require `auth.uid == userId`. There are no public collections.

---

## Naming Conventions

### Dart (Mobile)
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **BLoC files**: `{feature}_bloc.dart`, `{feature}_event.dart`, `{feature}_state.dart`
- **Cubit files**: `{feature}_cubit.dart`
- **Repositories**: `{feature}_repository.dart` (abstract), `{feature}_repository_impl.dart` (concrete)
- **Models**: `{feature}.dart` or `{feature}_model.dart` inside `domain/`
- **Pages**: `{name}_page.dart` or `add_{feature}_page.dart`
- **Imports**: Always use absolute package imports (`package:twoaxis_finance/...`), never relative

### TypeScript/React (Web)
- **Files**: `PascalCase.tsx` for components/pages, `camelCase.ts` for utilities/hooks
- **Components**: Named exports, `PascalCase` function components
- **Pages**: `{Name}Page.tsx` (e.g. `DashboardPage.tsx`, `BillsPage.tsx`)
- **Contexts**: `{Name}Context.tsx` with matching `use{Name}` hook
- **Hooks**: `use{Name}.ts`
- **Types**: Interfaces in `types/index.ts`

### CSS (Web)
- Tailwind v4 custom theme tokens defined in `@theme {}` inside `index.css`
- Custom color tokens follow `--color-{name}-{variant}` pattern (e.g. `--color-surface-dark`, `--color-container-light`)
- Dark mode via `@custom-variant dark (&:where(.dark, .dark *))` — toggling `.dark` class on `<html>`

---

## Development Commands

### Firebase Emulators (required for local development)
```bash
# Start emulators (Auth on :9099, Firestore on :8080, UI enabled)
firebase emulators:start
```

Both mobile (in `kDebugMode`) and web (in `import.meta.env.DEV`) auto-connect to emulators.

### Mobile
```bash
cd mobile
flutter pub get                          # Install dependencies
flutter analyze                          # Run linter (enforced in CI)
flutter build apk --debug               # Debug APK
flutter build apk --release             # Release APK
flutter build appbundle --release        # Release AAB (for Play Store)
```

### Web
```bash
cd web
npm install                              # Install dependencies
npm run dev                              # Start Vite dev server
npm run build                            # Type-check + production build (output: web/dist/)
npm run lint                             # Run OxLint
npm run preview                          # Preview production build
```

### Website
No build step. Edit HTML/CSS files directly in `website/`.

### Firebase Deployment
```bash
firebase deploy --only firestore:rules   # Deploy Firestore rules
firebase deploy --only hosting:website   # Deploy marketing site
firebase deploy --only hosting:web       # Deploy web app (from web/dist/)
```

---

## CI/CD Pipelines

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `mobile-pull-request.yaml` | PR to any branch with `mobile/` changes | `flutter analyze` + build debug APK + build debug AAB |
| `mobile-push.yaml` | Push tag `v*` | Build release AAB → deploy to Google Play (production/draft) |
| `firebase-hosting-pull-request.yml` | PR with `website/` changes | Preview deploy to Firebase Hosting |
| `firebase-hosting-merge.yml` | Push to `release` branch with `website/` changes | Live deploy to Firebase Hosting |

Flutter version is pinned to `3.38.5` in all CI workflows.

---

## Linting Rules

### Dart
Configured in `mobile/analysis_options.yaml` (extends `package:flutter_lints/flutter.yaml`):
- `always_declare_return_types: true`
- `always_use_package_imports: true` (no relative imports)
- `prefer_single_quotes: false` (use double quotes)
- `constant_identifier_names: false` (allows non-SCREAMING_CASE constants)
- Various `unnecessary_*` rules enabled
- `annotate_overrides: true`
- CI runs `flutter analyze` — treat warnings as errors

### TypeScript
Configured in `web/tsconfig.app.json`:
- `noUnusedLocals: true`
- `noUnusedParameters: true`
- `erasableSyntaxOnly: true`
- `verbatimModuleSyntax: true` (use `import type` for type-only imports)
- `noFallthroughCasesInSwitch: true`

### OxLint (Web)
Configured in `web/.oxlintrc.json`:
- `react/rules-of-hooks: error`
- `react/only-export-components: warn` (allows constant exports)
- Plugins: `react`, `typescript`, `oxc`

---

## Emulator Configuration

| Service | Port |
|---------|------|
| Firebase Auth | 9099 |
| Firestore | 8080 |
| Emulator UI | Auto-assigned |

- **Mobile emulator host**: `10.0.2.2` (Android emulator loopback to host)
- **Web emulator host**: `127.0.0.1`
- Only connects to emulators in debug/dev mode — never in production builds.

---

## Design System

### Brand Color
- **Primary**: `#A72222` (dark red) — used in both mobile and web theme definitions
- **Primary hover**: `#C42828`
- **Primary dark**: `#5E1919`

### Font
- **Sen** (Google Fonts) — used across mobile (`fontFamily: "Sen"`) and web

### Theme
- Dark mode is the default on both platforms
- Light/dark theme persisted per-platform (`SharedPreferences` on mobile, `localStorage` on web)

### Shared Categories
Both platforms use identical category lists:
- **Expense**: Food & Drinks, Transportation, Shopping, Entertainment, Bills & Utilities, Health, Education, Travel, Gifts, Other
- **Income**: Salary, Freelance, Business, Investments, Gifts, Other

---

## Common Mistakes to Avoid

1. **Do not commit emulator connection changes** — both `mobile/lib/main.dart` and `web/src/firebase.ts` conditionally connect to emulators. Never remove the debug/dev guards or hardcode production endpoints.
2. **Always use package imports in Dart** — `always_use_package_imports` is enforced. Use `package:twoaxis_finance/...` not `../`.
3. **Use `import type` in TypeScript** — `verbatimModuleSyntax` is enabled. Type-only imports must use `import type { ... }`. The `fix_types.cjs` script exists to help fix this.
4. **Scope all Firestore data to `users/{userId}/`** — the security rules only allow access to a user's own document tree. Creating top-level collections will be inaccessible.
5. **Do not add Firestore queries without checking index requirements** — composite queries may require indexes in `firestore.indexes.json`.
6. **Website deploys from `release` branch, not `master`** — the hosting merge workflow triggers on push to `release`.
7. **Mobile release builds require signing** — CI uses secrets for keystore. Local release builds need `mobile/android/key.properties`.
8. **Flutter version is pinned in CI** — use Flutter `3.38.5` stable to match CI. Mismatched versions may cause analysis or build failures.
9. **Web production build serves from `web/dist/`** — Firebase Hosting target `web` serves `web/dist/` with SPA rewrite. Always run `npm run build` in `web/` before deploying.
10. **Both platforms must stay in sync on domain model changes** — categories, currencies, and Firestore document structure are shared between mobile and web. Changes to one must be reflected in the other.
