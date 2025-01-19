import 'package:base_dependencies/base_dependencies.dart';
import 'package:components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DiagnosticPropertiesBuilder, SystemUiOverlayStyle;

class AppOptions extends Equatable {
  const AppOptions({
    required this.themeMode,
    required this.locale,
  });

  final ThemeMode themeMode;
  final Locale locale;

  /// Returns a [SystemUiOverlayStyle] based on the [ThemeMode] setting.
  /// In other words, if the theme is dark, returns light; if the theme is
  /// light, returns dark.
  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
      case ThemeMode.dark:
        brightness = Brightness.dark;
      case ThemeMode.system:
        brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }

    final SystemUiOverlayStyle overlayStyle =
        brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }

  AppOptions copyWith({ThemeMode? themeMode, Locale? locale}) => AppOptions(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );

  static AppOptions of(BuildContext context) {
    final _ModelBindingScope scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    return scope.modelBindingState.currentModel;
  }

  static void update(BuildContext context, AppOptions newModel) {
    final _ModelBindingScope scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>()!;
    scope.modelBindingState.updateModel(newModel);
  }

  @override
  List<Object> get props => <Object>[themeMode, locale];
}

class _ModelBindingScope extends InheritedWidget {
  const _ModelBindingScope({
    required this.modelBindingState,
    required super.child,
  });

  final _ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<_ModelBindingState>('modelBindingState', modelBindingState));
  }
}

class ModelBinding extends StatefulWidget {
  const ModelBinding({
    required this.initialModel,
    required this.child,
    super.key,
  });

  final AppOptions initialModel;
  final Widget child;

  @override
  State<ModelBinding> createState() => _ModelBindingState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppOptions>('initialModel', initialModel));
  }
}

class _ModelBindingState extends State<ModelBinding> {
  late AppOptions currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  void updateModel(AppOptions newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) => KeyboardDismiss(
        child: _ModelBindingScope(
          modelBindingState: this,
          child: widget.child,
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppOptions>('currentModel', currentModel));
  }
}
