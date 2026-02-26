import 'dart:async';
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

class InternetConnectionPage extends StatefulWidget {
  const InternetConnectionPage({super.key});

  @override
  InternetConnectionPageState createState() => InternetConnectionPageState();
}

class InternetConnectionPageState extends State<InternetConnectionPage> {
  late StreamSubscription<List<ConnectivityResult>> _connectivityChangedListener;
  final ValueNotifier<bool> _isLoaded = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _connectivityChangedListener = AppInjector.instance.get<Connectivity>().onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> status) async {
    if (!status.contains(ConnectivityResult.none) &&
        await AppInjector.instance.get<NetworkInfo>().isConnected &&
        mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Нет доступа к интернету',
            style: context.textStyle.defaultW600x20.copyWith(color: context.color.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Проверьте подключение к интернету',
            style: context.textStyle.defaultW400x16.copyWith(color: context.color.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: Dimensions.kPaddingAll16,
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoaded,
          builder: (_, bool isLoading, _) => CustomLoadingButton(
            isLoading: isLoading,
            child: const Text('Попробовать снова'),
            onPressed: () {
              _isLoaded.value = true;
              Future<void>.delayed(const Duration(milliseconds: 1), () async {
                final bool isConnected = await AppInjector.instance.get<NetworkInfo>().isConnected;
                if (isConnected && context.mounted) {
                  context.pop();
                } else if (mounted) {
                  _isLoaded.value = false;
                }
              });
            },
          ),
        ),
      ),
    ),
  );

  @override
  void dispose() {
    unawaited(_connectivityChangedListener.cancel());
    _isLoaded.dispose();
    super.dispose();
  }
}
