import 'package:flutter/material.dart';

part 'mixin/home_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    key: const Key('home'),
    appBar: AppBar(title: const Text('Home')),
    body: Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverList.separated(
              itemCount: 100,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (_, index) => ListTile(tileColor: Colors.transparent, title: Text('Item ${index + 1}')),
            ),
          ),
        ],
      ),
    ),
  );
}
