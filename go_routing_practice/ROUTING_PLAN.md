# Go Router Practice — Flutter Learning Project

## Overview

This project is a structured **learning app** designed to teach `go_router` end-to-end using:

- 🏗 **Clean Architecture** (Domain → Data → Presentation layers)
- 📁 **Feature-First** folder structure
- 🧊 **BLoC** for state management
- 🧭 **go_router** with guards, nested navigation, redirects, and deep links

The app will be a simple **E-Commerce-style** demo app with real-world routing scenarios like authentication guards, nested bottom-nav tabs, deep links, and query params.

---

## Proposed App Features (Learning Scenarios)

| # | Feature | go_router Concept Covered |
|---|---------|--------------------------|
| 1 | Splash Screen | Initial location, redirect on boot |
| 2 | Onboarding (3 pages) | `ShellRoute`, nested stack |
| 3 | Login / Register | Auth guard redirect, form routing |
| 4 | Home (Bottom Nav) | `StatefulShellRoute` (persistent nav) |
| 5 | Product List → Detail | Named routes, path params `/products/:id` |
| 6 | Cart (tab) | Tab-aware nested router |
| 7 | Profile / Settings | Query params, sub-routes |
| 8 | Deep Link Handler | `GoRoute` with deep link path |
| 9 | Error / 404 Page | `errorBuilder`, custom 404 |
| 10 | Protected Routes | `redirect` callback with auth BLoC |

---

## Architecture Principles

```
lib/
├── core/                         # Shared utilities, DI, theme
│   ├── di/                       # Dependency injection (get_it)
│   ├── router/                   # go_router configuration
│   ├── theme/                    # App theme & colors
│   └── utils/                    # Extensions, constants
│
├── features/                     # Feature-first modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/     # Abstract contracts
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/             # AuthBloc, AuthEvent, AuthState
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/            # Shell wrapper page
│   │
│   ├── products/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/            # product_list_page, product_detail_page
│   │       └── widgets/
│   │
│   ├── cart/
│   │   └── presentation/
│   │
│   └── profile/
│       └── presentation/
│
└── main.dart
```

---

## Dependencies to Add

```yaml
dependencies:
  go_router: ^15.0.0         # Routing
  flutter_bloc: ^9.0.0       # BLoC state management
  bloc: ^9.0.0
  equatable: ^2.0.7          # Value equality for states/events
  get_it: ^8.0.0             # Service locator / DI
  injectable: ^2.5.0         # Code-gen DI annotations

dev_dependencies:
  injectable_generator: ^2.7.0
  build_runner: ^2.4.0
  bloc_test: ^9.0.0
  mocktail: ^1.0.4
```

---

## go_router Architecture Deep-Dive

### 1. Router Configuration (`core/router/app_router.dart`)

```
AppRouter (class)
  └── GoRouter instance
       ├── initialLocation: '/splash'
       ├── redirect: auth guard logic
       ├── errorBuilder: 404 page
       └── routes:
            ├── /splash         → SplashPage
            ├── /onboarding     → ShellRoute (3-step wizard)
            ├── /login          → LoginPage
            ├── /register       → RegisterPage
            └── /home           → StatefulShellRoute (bottom nav)
                 ├── /products  → ProductListPage
                 │    └── /products/:id → ProductDetailPage
                 ├── /cart      → CartPage
                 └── /profile   → ProfilePage
                      └── /profile/settings → SettingsPage
```

### 2. Auth Guard Pattern

```dart
// In GoRouter redirect callback
redirect: (context, state) {
  final authBloc = context.read<AuthBloc>();
  final isLoggedIn = authBloc.state is AuthAuthenticated;
  final isOnAuthPage = state.matchedLocation.startsWith('/login');
  final isOnboarding = state.matchedLocation.startsWith('/onboarding');

  if (!isLoggedIn && !isOnAuthPage && !isOnboarding) {
    return '/login';
  }
  if (isLoggedIn && isOnAuthPage) {
    return '/home/products';
  }
  return null; // no redirect
}
```

### 3. StatefulShellRoute (Persistent Bottom Nav)

`StatefulShellRoute` keeps each tab's navigation stack alive independently — ideal for bottom navigation bars. Each branch is a `StatefulShellBranch`.

### 4. Deep Link Support

```dart
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductDetailPage(productId: id);
  },
)
```

Accessing `state.uri.queryParameters` for optional query params like `/products/1?ref=home`.

---

## Step-by-Step Build Sequence

### Phase 1 — Foundation (Dependencies & Core Setup)
- [ ] Add dependencies to `pubspec.yaml`
- [ ] Set up `core/theme/` (colors, text styles)
- [ ] Set up `core/di/` with `get_it` + `injectable`
- [ ] Create base `AppRouter` class in `core/router/`

### Phase 2 — Auth Feature (with BLoC + guard)
- [ ] Create `AuthEntity`, `AuthRepository` (domain)
- [ ] Create mock `AuthRepositoryImpl` (data)
- [ ] Create `AuthBloc` with login/logout events & states
- [ ] Create `LoginPage` and `RegisterPage`
- [ ] Wire auth guard in router redirect

### Phase 3 — Onboarding (ShellRoute + nested pages)
- [ ] Create `OnboardingPage` with 3 sub-pages
- [ ] Use `ShellRoute` for wizard-style navigation
- [ ] Store onboarding completion in `SharedPreferences`
- [ ] Redirect from splash based on onboarding & auth state

### Phase 4 — Home Shell (StatefulShellRoute + Bottom Nav)
- [ ] Create `HomeShellPage` with `BottomNavigationBar`
- [ ] Set up `StatefulShellRoute` with 3 branches
- [ ] Ensure each tab preserves its own navigation stack

### Phase 5 — Products Feature (path params + deep links)
- [ ] Create `ProductEntity`, `ProductRepository` (domain)
- [ ] Create mock product data source (data)
- [ ] Create `ProductBloc`
- [ ] Create `ProductListPage` and `ProductDetailPage`
- [ ] Wire `/products/:id` route with path params
- [ ] Add query param demo: `?ref=deeplink`

### Phase 6 — Cart & Profile (sub-routes + query params)
- [ ] Cart page with `CartBloc`
- [ ] Profile page with `/profile/settings` sub-route
- [ ] Settings with query param example

### Phase 7 — Error Handling & Polish
- [ ] Custom `errorBuilder` → `NotFoundPage`
- [ ] Named route constants (`AppRoutes` class)
- [ ] Route observer / analytics hook
- [ ] Unit tests for BLoCs
- [ ] Widget tests for key pages

---

## Key go_router Concepts Covered (Summary)

| Concept | Where Demonstrated |
|---|---|
| `GoRoute` | Every route |
| `path parameters` | `/products/:id` |
| `query parameters` | `/profile?tab=orders` |
| `named routes` | `AppRoutes` constants |
| `redirect` | Auth guard |
| `ShellRoute` | Onboarding wizard |
| `StatefulShellRoute` | Bottom navigation |
| `errorBuilder` | 404 page |
| `GoRouterState` | Extracting params/query |
| `context.go()` vs `context.push()` | Navigation examples |
| `context.pop()` / `canPop()` | Back handling |
| Deep links | Universal link handling |
| Route observers | Analytics / logging |

---

## Open Questions

> **App Complexity**: Should the data layer use real API calls (e.g., `dio` + JSONPlaceholder) or mock/local data for simplicity? Mock data recommended for learning focus.

> **DI Strategy**: Use `get_it` with `injectable` (code-gen) or manual `get_it` setup? Injectable is more realistic/scalable but adds build_runner step.

> **Testing**: Should we include BLoC unit tests and widget tests as part of each feature phase?

---

## Verification Plan

### After each phase:
- `flutter analyze` — no warnings/errors
- Hot reload confirms routing works end-to-end
- Named routes navigate correctly
- Auth guard redirects work as expected
- BLoC states transition correctly

### Final:
- Full navigation flow demo: Splash → Onboarding → Login → Home → Product Detail → Back
- Deep link test: open `myapp://products/42`
- Auth guard test: accessing protected route without login → redirect to `/login`
