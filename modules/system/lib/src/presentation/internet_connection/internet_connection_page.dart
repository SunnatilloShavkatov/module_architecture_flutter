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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Нет доступа к интернету',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Проверьте подключение к интернету',
            style: TextStyle(fontSize: 17, color: Color(0xff818C99), fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoaded,
          builder: (_, bool isLoading, _) => CustomLoadingButton(
            isLoading: isLoading,
            child: const Text('Попробовать снова'),
            onPressed: () async {
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
