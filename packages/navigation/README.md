# Navigation Package

Routing and navigation utilities for the Module Architecture Mobile project.

## Overview

The `navigation` package provides routing infrastructure, navigation utilities, and route definitions used across all feature modules.

## Features

- **Route Names**: Centralized route name constants (`NameRoutes`)
- **Navigation Observer**: Route navigation tracking (`RouteNavigationObserver`)
- **Custom Routes**: Material sheet routes and transitions
- **Global Navigator**: Root navigator key for app-wide navigation
- **Chuck Interceptor**: Network debugging tool integration

## Installation

Add to your module's `pubspec.yaml`:

```yaml
dependencies:
  navigation:
    path: ../../packages/navigation
```

## Usage

### Import

```dart
import 'package:navigation/navigation.dart';
```

### Route Navigation

```dart
// Navigate to a route
Navigator.pushNamed(context, NameRoutes.login);

// Navigate with arguments
Navigator.pushNamed(
  context,
  NameRoutes.userDetail,
  arguments: {'userId': '123'},
);

// Replace current route
Navigator.pushReplacementNamed(context, NameRoutes.home);

// Pop and push
Navigator.popAndPushNamed(context, NameRoutes.settings);
```

### Defining Module Routes

```dart
final class AuthRouter implements AppRouter<RouteBase> {
  const AuthRouter();

  @override
  List<GoRoute> getRouters(Injector di) => [
    GoRoute(
      path: NameRoutes.login,
      name: NameRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: NameRoutes.forgotPassword,
      name: NameRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
  ];
}
```

### Global Navigator

```dart
// Use global navigator key for navigation without context
rootNavigatorKey.currentState?.pushNamed(NameRoutes.login);
```

## Route Names

All route names are defined in `NameRoutes` class:

```dart
class NameRoutes {
  // Auth routes
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  
  // Home routes
  static const String home = '/home';
  
  // More routes
  static const String settings = '/settings';
  static const String profile = '/profile';
}
```

## Rules

### When to Use

✅ **MUST** use for:
- All navigation and routing
- Route name constants
- Custom page transitions
- Global navigation

✅ **MUST** use in:
- All feature modules
- Router implementations
- Navigation-related code

### When NOT to Use

❌ **NEVER**:
- Hardcode route names as strings
- Create navigation utilities in modules
- Define routes outside of module routers

## Dependencies

- `go_router` - Declarative routing
- `chuck_interceptor` - Network debugging

## Best Practices

1. **Use route constants**: Never hardcode route strings
2. **Module-based routing**: Each module defines its own routes
3. **Global navigator**: Use for navigation without context
4. **Type-safe navigation**: Use route constants to prevent typos

## Related Documentation

- [Module Structure](../../docs/architecture/module_structure.md)
- [Flutter Rules](../../flutter-rules.md#14-package-usage-rules)

## License

[Add your license here]
