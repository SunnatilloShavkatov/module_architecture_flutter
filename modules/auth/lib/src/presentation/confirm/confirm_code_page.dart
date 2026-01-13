import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({super.key});

  @override
  State<ConfirmCodePage> createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Введите код из смс')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text('Здесь будет ввод кода из смс'),
        Pinput(smsRetriever: AppInjector.instance.get<SmsRetriever>()),
      ],
    ),
  );
}
