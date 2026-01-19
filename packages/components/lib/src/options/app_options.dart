import 'dart:async';

import 'package:components/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

@immutable
final class AppOptions {
  const AppOptions({required this.themeMode, required this.locale});

  final Locale locale;
  final ThemeMode themeMode;

  AppOptions copyWith({ThemeMode? themeMode, Locale? locale}) =>
      AppOptions(themeMode: themeMode ?? this.themeMode, locale: locale ?? this.locale);

  static AppOptions of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final _ModelBindingScope? scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
      assert(scope != null, 'AppOptions.of: ModelBinding not found.');
      return scope!.model;
    } else {
      final InheritedElement? element = context.getElementForInheritedWidgetOfExactType<_ModelBindingScope>();
      final widget = element?.widget as _ModelBindingScope?;
      assert(widget != null, 'AppOptions.of(listen:false): ModelBinding not found.');
      return widget!.model;
    }
  }

  static void update(BuildContext context, AppOptions newModel) {
    final _ModelBindingState? state = context.findAncestorStateOfType<_ModelBindingState>();
    assert(state != null, 'AppOptions.update: ModelBinding not found.');
    state!.updateModel(newModel);
  }

  @override
  int get hashCode => Object.hash(themeMode, locale);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AppOptions && other.themeMode == themeMode && other.locale == locale);

  @override
  String toString() => 'AppOptions(themeMode: $themeMode, locale: $locale)';
}

class _ModelBindingScope extends InheritedWidget {
  const _ModelBindingScope({required this.model, required super.child});

  final AppOptions model;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => model != oldWidget.model;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppOptions>('model', model));
  }
}

class ModelBinding extends StatefulWidget {
  const ModelBinding({super.key, required this.child, required this.initialModel});

  final AppOptions initialModel;
  final Widget child;

  @override
  State<ModelBinding> createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ModelBinding> {
  late AppOptions _currentModel;
  bool _isDateFormattingInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentModel = widget.initialModel;
    unawaited(_initializeDateFormatting());
  }

  Future<void> _initializeDateFormatting() async {
    if (!_isDateFormattingInitialized) {
      await initializeDateFormatting();
      _isDateFormattingInitialized = true;
    }
    Intl.defaultLocale = _currentModel.locale.toString();
  }

  void updateModel(AppOptions newModel) {
    if (newModel != _currentModel) {
      setState(() {
        _currentModel = newModel;
      });
    }
  }

  @override
  void didUpdateWidget(covariant ModelBinding oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialModel != oldWidget.initialModel) {
      _currentModel = widget.initialModel;
    }
  }

  @override
  Widget build(BuildContext context) => KeyboardDismiss(
    key: const Key('keyboardDismiss'),
    child: _ModelBindingScope(model: _currentModel, child: widget.child),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppOptions>('currentModel', _currentModel));
  }
}
