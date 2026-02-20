# Presentation Implementation Plan (Page + Bloc + Widget + Mixin)

This plan is mandatory when implementing presentation-layer features.

## 1. Pre-Check (Project-Aware)

Before writing code:

1. identify target module (`auth`, `home`, `initial`, `main`, `more`, `system`);
2. inspect existing folder naming in that module (`repo` vs `repository`, `repos` vs `repository`);
3. inspect existing presentation style for the same module.

Do not generate generic placeholder names in final implementation.

## 2. File Placement (Exact)

For feature `<feature>` in module `<module>`:

- page: `modules/<module>/lib/src/presentation/<feature>/<feature>_page.dart`
- bloc: `modules/<module>/lib/src/presentation/<feature>/bloc/<feature>_bloc.dart`
- event: `modules/<module>/lib/src/presentation/<feature>/bloc/<feature>_event.dart`
- state: `modules/<module>/lib/src/presentation/<feature>/bloc/<feature>_state.dart`
- mixin: `modules/<module>/lib/src/presentation/<feature>/mixin/<feature>_mixin.dart`
- widgets: `modules/<module>/lib/src/presentation/<feature>/widgets/*.dart`

If module already uses a slightly different local layout, preserve that layout.

## 3. Bloc Construction Rules

### 3.1 Class and `part` structure

- bloc class must be `final class`;
- root event/state classes must be `sealed class`;
- concrete event/state classes must be `final class`;
- event/state files must be connected with `part`.

Example structure:

```dart
import 'package:core/core.dart';

part 'profile_event.dart';
part 'profile_state.dart';

final class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getProfile) : super(const ProfileInitialState()) {
    on<GetProfileEvent>(_getProfileHandler);
  }

  final GetProfileUseCase _getProfile;

  Future<void> _getProfileHandler(GetProfileEvent event, Emitter<ProfileState> emit) async {
    if (state is ProfileLoadingState) {
      return;
    }
    emit(const ProfileLoadingState());
    final result = await _getProfile();
    result.fold(
      (failure) => emit(ProfileErrorState(message: failure.message)),
      (data) => emit(ProfileLoadedState(profile: data)),
    );
  }
}
```

### 3.2 Handler naming (Strict)

Use handler suffix `Handler` with verb-first private names:

- `_getXxxHandler`
- `_createXxxHandler`
- `_updateXxxHandler`
- `_deleteXxxHandler`
- `_resetXxxHandler`

Do not introduce generic `_onXxx` in new code.

### 3.3 Event naming (Strict)

Use explicit event names:

- `GetXxxEvent`
- `CreateXxxEvent`
- `UpdateXxxEvent`
- `DeleteXxxEvent`
- `ResetXxxEvent`

### 3.4 State naming (Strict)

Base pattern:

- `XxxInitialState`
- `XxxLoadingState`
- `XxxLoadedState` or `XxxSuccessState`
- `XxxErrorState` or `XxxFailureState`

For multi-flow pages, create grouped sealed states:

- `XxxInfoState`
- `XxxCodeState`
- `XxxListState`

This pattern is used in reference modules and prevents mixed UI rebuild logic.

### 3.5 Concurrency decision (Mandatory)

- `droppable`: repeated load events where stale duplicates should be ignored.
- `throttle`: rapid button-triggered events where frequency must be limited.
- `debounce`: high-frequency input events (search/filter typing).
- `sequential`: order-dependent events where each must complete in order.

## 4. Page Rules

- prefer `StatefulWidget` for bloc-driven pages;
- call initial events in `initState()`;
- use `BlocListener` for side effects;
- use `BlocBuilder` for rendering;
- use `buildWhen`/`listenWhen` when state groups are separate;
- navigation only via GoRouter named methods.

## 5. Mixin Rules

- mixin file must be `part of` page file;
- mixin target must be `on State<FeaturePage>`;
- keep `_handleStates` in mixin for listener logic;
- keep controllers, focus nodes, timers, notifiers in mixin;
- dispose all resources;
- include typed bloc accessor:
  - `FeatureBloc get bloc => context.read<FeatureBloc>();`

## 6. Widget Rules

- widgets should be small and focused;
- use `StatelessWidget` by default;
- pass data via constructor;
- no repository/data-source usage in widgets;
- page/mixin decides bloc dispatch and navigation.

## 7. Why This Plan

- prevents architecture leakage into UI layer;
- keeps async race conditions under control;
- keeps page lifecycle and cleanup predictable;
- keeps code style aligned with existing production modules.

## 8. Definition of Done

- [ ] owner module stated
- [ ] feature files added in correct module paths
- [ ] bloc is `final class`, events/states sealed+final in `part` files
- [ ] handler names follow `_<verb><Target>Handler`
- [ ] explicit event/state naming is used (no generic placeholders)
- [ ] listener logic is in mixin `_handleStates`
- [ ] side effects are not inside widget build method
- [ ] errors shown through `showErrorMessage`
- [ ] DI and router updated in module files
- [ ] touched files list included in final delivery
