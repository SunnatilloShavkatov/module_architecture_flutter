import 'package:components/src/top_snack_bar/top_snack_bar.dart';
import 'package:material_ui/material_ui.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
      boxShadow: const [BoxShadow(blurRadius: 15.5, offset: Offset(0, 4), color: Color.fromRGBO(255, 0, 0, 0.44))],
    ),
  );
}

void showSuccessMessage(BuildContext context, {required String message}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(message: message, backgroundColor: Theme.of(context).colorScheme.secondary),
  );
}

void showInfoMessage(BuildContext context, {required String message}) {
  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(message: message, backgroundColor: Theme.of(context).colorScheme.primary),
  );
}
