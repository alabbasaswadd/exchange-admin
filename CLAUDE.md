# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**exchange_admin** is a Flutter admin portal for MikroNet, an ISP management application. It targets Android, iOS, and Web.

## Common Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Generate code (Freezed models, Retrofit services, JsonSerializable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Regenerate localization files
flutter gen-l10n

# Build targets
flutter build apk
flutter build web
```

## Architecture

The app uses a **feature-based layered architecture** with BLoC (Cubit) state management, GetIt for dependency injection, Go Router for navigation, and Retrofit + Dio for networking.

### Directory Structure

```
lib/
├── main.dart           # Entry point — initializes DI (setupDI()) then runs app
├── routes.dart         # Go Router config with auth redirect logic
├── theme.dart          # Light/dark MaterialTheme definitions
├── l10n/               # ARB localization files (en, ar) — Arabic is default locale
├── core/
│   ├── components/     # Reusable UI widgets (AppButton, AppText, AppTextField, etc.)
│   ├── constants/      # Colors, image paths, shared functions, ErrorModel
│   ├── networking/     # DioFactory, BaseApi, ApiResult<T>
│   └── di/             # GetIt service locator setup
└── pages/
    ├── startup/        # Splash screen + StartupCubit (token check on launch)
    └── auth/signin/    # Sign-in screen + SigninCubit
```

### Feature Structure

Each feature under `pages/` follows this pattern:

```
feature/
├── api/
│   ├── feature_api.dart          # Wrapper class extending BaseApi
│   └── feature_api_service.dart  # Retrofit @RestApi interface (code-generated)
├── cubit/
│   ├── feature_cubit.dart        # extends BaseCubit<FeatureState>
│   └── feature_state.dart        # @freezed state class
├── model/
│   └── *.dart                    # @JsonSerializable / @freezed models
└── screen/
    └── feature_screen.dart       # UI widget
```

### Key Base Classes

- **`BaseCubit<TState>`** (`core/`) — All Cubits extend this. Provides `executeApi()` for standardized API calls, `formKey`, `validateForm()`, and controller disposal helpers.
- **`BaseApi`** — All API wrapper classes extend this. Handles common error mapping.
- **`ApiResult<T>`** — Sealed Success/Failure return type for all API calls.

### State Management Pattern

States use Freezed unions. Example:

```dart
@freezed
class SigninState with _$SigninState {
  const factory SigninState.initial() = _Initial;
  const factory SigninState.loading() = _Loading;
  const factory SigninState.success(AccountModel account) = _Success;
  const factory SigninState.failure(ErrorModel error) = _Failure;
}
```

Cubits call `executeApi()` which wraps API calls and emits loading/success/failure states automatically.

### Navigation & Auth Flow

Routes are defined in `routes.dart` using Go Router. The redirect logic checks SharedPreferences for a cached token:
- No token → `/signin`
- Valid token → `/home`

Token is stored with key `'token'` in SharedPreferences. `DioFactory` reads this token and sets it as the Authorization header on all requests.

### Networking

- **Base URL**: `http://network-isp-user-api.runasp.net/network-user-api/`
- **Timeout**: 30 seconds
- Requests/responses are logged via `PrettyDioLogger` in debug mode
- Retrofit generates the API service implementations — run `build_runner` after changing any `@RestApi` interface

### Localization

- Supports English (`en`) and Arabic (`ar`); **Arabic is the default locale**
- ARB files live in `lib/l10n/`
- After editing ARB files, run `flutter gen-l10n` to regenerate the `AppLocalizations` class
- Custom font: **Cairo-Bold** (loaded from `assets/fonts/cairo/`)

### Code Generation

Three generators are in use — always run `build_runner` after modifying any annotated file:

| Annotation | Generator | Purpose |
|---|---|---|
| `@freezed` | Freezed | Immutable state/model classes |
| `@JsonSerializable` | json_serializable | JSON encode/decode |
| `@RestApi` | Retrofit | HTTP client implementations |

Generated files end in `.freezed.dart`, `.g.dart` — do not edit them manually.
