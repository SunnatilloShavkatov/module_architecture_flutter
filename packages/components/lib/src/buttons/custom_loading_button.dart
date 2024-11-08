import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({
    super.key,
    this.onPressed,
    this.child,
    this.isLoading = false,
  });

  final void Function()? onPressed;
  final Widget? child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator.adaptive(),
              )
            : child,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<void Function()?>.has("onPressed", onPressed))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading));
  }
}
