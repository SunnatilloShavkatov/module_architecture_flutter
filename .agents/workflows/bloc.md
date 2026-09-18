# /bloc

Read only these two sources, nothing else:
1. `modules/notifications/lib/src/presentation/notifications/bloc/notifications_bloc.dart` — reference
   (need a multi-operation sealed state? also `notifications_state.dart` next to it)
2. `docs/rules/bloc.md` — TL;DR block (read the rest only if you need a new pattern)

Write: `modules/<module>/lib/src/presentation/<feature>/bloc/<feature>_bloc.dart`
+ `part`-ed `_event.dart` and `_state.dart`.

Requirements:
- event `<Verb><Noun>Event`, state `<Noun><Status>State`, handler `_<verb><target>Handler`
- every `on<Event>()` has an explicit `transformer:` (`droppable()`, `throttle()`, `debounce()`)
- dependencies `private final`, no mutable field in the bloc (data lives in the mixin)
- event/state root is `sealed class` + `part of`; bloc is `final class`
- constructor `const new(...)` (bloc's own constructor is not `const`)

Don't use analyze/test during the turn. On a guard message — fix that exact line.

Task is taken from the user.

Rules source: `AGENTS.md`. No analyze/test/pub get during a turn (§7).
