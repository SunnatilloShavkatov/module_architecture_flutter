import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.settings});

  final GoRouterState settings;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: const Center(child: Text('404')),
    bottomNavigationBar: SafeArea(
      child: CustomLoadingButton(
        onPressed: () {
          context.pop();
        },
        child: Text(context.l10n.goBack),
      ),
    ),
  );
}
