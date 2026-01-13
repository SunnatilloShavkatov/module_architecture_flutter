import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CustomLoadingButton extends StatefulWidget {
  const CustomLoadingButton({super.key, this.onPressed, this.child, this.isLoading = false});

  final void Function()? onPressed;
  final Widget? child;
  final bool isLoading;

  @override
  State<CustomLoadingButton> createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  final PublishSubject<void> _throttleSubject = PublishSubject<void>();

  @override
  void initState() {
    super.initState();
    _throttleSubject.throttleTime(const Duration(seconds: 1), trailing: false).listen((_) {
      if (!widget.isLoading && widget.onPressed != null && mounted) {
        widget.onPressed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
    onPressed: widget.onPressed == null
        ? null
        : () {
            if (widget.onPressed == null || widget.isLoading) {
              return;
            }
            _throttleSubject.add(null);
          },
    child: widget.isLoading
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator.adaptive())
        : widget.child,
  );

  @override
  void dispose() {
    unawaited(_throttleSubject.close());
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function()?>.has('onPressed', widget.onPressed))
      ..add(DiagnosticsProperty<bool>('isLoading', widget.isLoading));
  }
}
