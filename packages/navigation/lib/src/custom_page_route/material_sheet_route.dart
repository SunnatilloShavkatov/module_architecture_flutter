import 'package:flutter/material.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

class MaterialSheetRoute<T> extends SheetRoute<T> {
  MaterialSheetRoute({
    super.settings,
    required WidgetBuilder builder,
    super.barrierColor = Colors.black54,
    super.fit = SheetFit.loose,
    super.barrierDismissible,
    bool enableDrag = true,
    super.stops,
    double initialStop = 1,
    super.duration = const Duration(milliseconds: 300),
  }) : super(
          builder: (context) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height - MediaQuery.viewPaddingOf(context).top,
            ),
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: Theme.of(context).bottomSheetTheme.shape,
              child: SheetMediaQuery(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      child: Container(
                        height: 4,
                        width: 48,
                        margin: const EdgeInsets.only(top: 12, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(2)),
                          color: Theme.of(context).bottomSheetTheme.dragHandleColor,
                        ),
                      ),
                    ),
                    Flexible(child: Builder(builder: builder)),
                  ],
                ),
              ),
            ),
          ),
          draggable: enableDrag,
          initialExtent: initialStop,
        );
}
