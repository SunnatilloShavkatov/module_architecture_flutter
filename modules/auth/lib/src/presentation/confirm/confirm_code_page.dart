import 'package:flutter/material.dart';

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({super.key});

  @override
  State<ConfirmCodePage> createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Введите код из смс')));
}
