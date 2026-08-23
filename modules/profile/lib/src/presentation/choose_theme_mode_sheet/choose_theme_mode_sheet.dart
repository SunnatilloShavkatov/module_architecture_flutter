import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';

class ChooseThemeModeSheet extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => SafeAreaWithMinimum(
    minimum: Dimensions.kPaddingAll16,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(context.l10n.chooseThemeMode, style: context.textTheme.headlineLarge, textAlign: TextAlign.center),
        Dimensions.kGap32,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.system);
          },
          child: Text(context.l10n.deviceMode),
        ),
        Dimensions.kGap16,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.dark);
          },
          child: Text(context.l10n.darkMode),
        ),
        Dimensions.kGap16,
        CustomLoadingButton(
          onPressed: () {
            context.pop(ThemeMode.light);
          },
          child: Text(context.l10n.lightMode),
        ),
      ],
    ),
  );
}
