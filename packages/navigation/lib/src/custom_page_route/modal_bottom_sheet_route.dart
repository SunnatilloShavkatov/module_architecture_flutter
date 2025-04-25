import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class UniversalSheetRoute<T> extends ModalSheetRoute<T> {
  UniversalSheetRoute({
    required super.settings,
    required WidgetBuilder builder,
    super.swipeDismissible = true,
    super.swipeDismissSensitivity = const SwipeDismissSensitivity(),
  }) : super(
          builder: (context) => ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height - MediaQuery.viewPaddingOf(context).top,
            ),
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: Theme.of(context).bottomSheetTheme.shape,
              child: DraggableSheet(
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
        );
}
