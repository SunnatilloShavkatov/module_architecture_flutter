import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platform_methods/platform_methods.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? id;
  String? status;
  bool isLoading = false;

  void _setError(Object error) {
    if (error is PlatformException) {
      status = '[${error.code}] ${error.message ?? 'Unknown platform error'}';
      return;
    }
    status = error.toString();
  }

  Future<void> _run(
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    setState(() {
      isLoading = true;
      status = null;
    });
    try {
      await action();
      setState(() {
        status = successMessage;
      });
    } catch (error) {
      setState(() {
        _setError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadDeviceId() async {
    setState(() {
      isLoading = true;
      status = null;
    });
    try {
      final String? getID = await PlatformMethods.instance.getDeviceId();
      setState(() {
        id = getID;
      });
    } catch (error) {
      setState(() {
        _setError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _checkReviewAvailability() async {
    setState(() {
      isLoading = true;
      status = null;
    });
    try {
      final bool isAvailable = await PlatformMethods.instance
          .isReviewAvailable();
      setState(() {
        status = 'Review available: $isAvailable';
      });
    } catch (error) {
      setState(() {
        _setError(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Platform Methods')),
        body: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              if (id != null) SelectableText('ID: $id'),
              if (status != null) SelectableText(status!),
              ElevatedButton(
                onPressed: isLoading ? null : _loadDeviceId,
                child: const Text('Get ID'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : _checkReviewAvailability,
                child: const Text('Check Review Availability'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _run(
                        PlatformMethods.instance.requestReview,
                        successMessage: 'Review flow requested',
                      ),
                child: const Text('Request Review'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _run(
                        PlatformMethods.instance.openStoreListing,
                        successMessage: 'Store listing opened',
                      ),
                child: const Text('Open Store Listing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
