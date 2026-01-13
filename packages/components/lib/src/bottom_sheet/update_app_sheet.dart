import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppUpdateBottomSheetWidget extends StatelessWidget {
  const AppUpdateBottomSheetWidget({required this.isForceUpdate, super.key, this.onTap, this.onClose});

  final void Function()? onTap;
  final void Function()? onClose;
  final bool isForceUpdate;

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Update Available', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('A new version of the app is available. Please update for the best experience.'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (!isForceUpdate) OutlinedButton(onPressed: onClose, child: const Text('Later')),
              ElevatedButton(onPressed: onTap, child: const Text('Update Now')),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function()?>.has('onTap', onTap))
      ..add(ObjectFlagProperty<void Function()?>.has('onClose', onClose))
      ..add(DiagnosticsProperty<bool>('isForceUpdate', isForceUpdate));
  }
}
