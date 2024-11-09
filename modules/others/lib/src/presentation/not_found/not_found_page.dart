import "package:flutter/material.dart";

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key, required this.settings});
  final RouteSettings settings;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: const Center(child: Text("404")),
        bottomNavigationBar: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Go back"),
          ),
        ),
      );
}
