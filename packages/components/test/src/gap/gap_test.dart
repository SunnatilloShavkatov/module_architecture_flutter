import 'package:components/src/gap/rendering/sliver_gap.dart';
import 'package:components/src/gap/widgets/gap.dart';
import 'package:components/src/gap/widgets/sliver_gap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('Gap', () {
    testWidgets('takes mainAxisExtent as width in Row', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(children: [SizedBox(width: 10, height: 10), Gap(24), SizedBox(width: 10, height: 10)]),
          ),
        ),
      );

      final Size size = tester.getSize(find.byType(Gap));
      expect(size.width, 24);
    });

    testWidgets('takes mainAxisExtent as height in Column', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(children: [SizedBox(width: 10, height: 10), Gap(16), SizedBox(width: 10, height: 10)]),
          ),
        ),
      );

      final Size size = tester.getSize(find.byType(Gap));
      expect(size.height, 16);
    });

    testWidgets('Gap.expand fills cross axis', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(width: 200, child: Column(children: [Gap.expand(12)])),
          ),
        ),
      );

      final Size size = tester.getSize(find.byType(Gap));
      expect(size.width, 200);
      expect(size.height, 12);
    });

    testWidgets('throws when not inside Flex or Scrollable', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Gap(10))));

      final dynamic exception = tester.takeException();
      expect(exception, isNotNull);
    });

    testWidgets('renders color when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Row(children: [Gap(20, color: Colors.red)]),
          ),
        ),
      );

      expect(find.byType(Gap), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('MaxGap takes at most mainAxisExtent', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Row(children: [MaxGap(50)])),
        ),
      );

      final Size size = tester.getSize(find.byType(MaxGap));
      expect(size.width, lessThanOrEqualTo(50));
    });
  });

  group('SliverGap', () {
    testWidgets('takes mainAxisExtent in scroll direction', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CustomScrollView(slivers: [SliverGap(40)])),
        ),
      );

      final RenderSliverGap renderObject = tester.renderObject<RenderSliverGap>(find.byType(SliverGap));
      expect(renderObject.geometry!.paintExtent, 40);
    });

    testWidgets('renders color when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(slivers: [SliverGap(30, color: Colors.blue)]),
          ),
        ),
      );

      expect(find.byType(SliverGap), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no color paints nothing without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: CustomScrollView(slivers: [SliverGap(15)])),
        ),
      );

      final RenderSliverGap renderObject = tester.renderObject<RenderSliverGap>(find.byType(SliverGap));
      expect(renderObject.color, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('mainAxisExtent 0 lays out with zero scrollExtent', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverGap(0),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
              ],
            ),
          ),
        ),
      );

      final RenderSliverGap renderObject = tester.renderObject<RenderSliverGap>(
        find.byType(SliverGap, skipOffstage: false),
      );
      expect(renderObject.geometry!.scrollExtent, 0);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sits between siblings in CustomScrollView', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 50)),
                SliverGap(25),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
          ),
        ),
      );

      final RenderSliverGap renderObject = tester.renderObject<RenderSliverGap>(find.byType(SliverGap));
      expect(renderObject.geometry!.scrollExtent, 25);
      expect(tester.takeException(), isNull);
    });

    testWidgets('updateRenderObject reflects new mainAxisExtent and color', (WidgetTester tester) async {
      Widget buildSliver(double extent, Color? color) => MaterialApp(
        home: Scaffold(
          body: CustomScrollView(slivers: [SliverGap(extent, color: color)]),
        ),
      );

      await tester.pumpWidget(buildSliver(10, Colors.green));
      await tester.pumpWidget(buildSliver(60, Colors.orange));

      final RenderSliverGap renderObject = tester.renderObject<RenderSliverGap>(find.byType(SliverGap));
      expect(renderObject.mainAxisExtent, 60);
      expect(renderObject.color, Colors.orange);
    });
  });
}
