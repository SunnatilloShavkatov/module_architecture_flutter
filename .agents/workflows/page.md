# /page

Reference (pick the one matching the task, not the whole folder — read the page + mixin pair):
- list + pagination → `modules/notifications/lib/src/presentation/notifications/`
- form + validation → `modules/auth/lib/src/presentation/login/`
- edit form + args + pop result → `modules/profile/lib/src/presentation/edit_profile/`

Rules: `docs/rules/page-mixin.md` TL;DR block.

Requirements:
- `mixin <Name>Mixin on State<...>`; UI data lives in the mixin, changes inside `_handleStates`
- derived value is a getter, never computed with `setState`
- every `BlocBuilder` / `BlocConsumer` has `buildWhen` + the sealed subfamily name
- `context.l10n.*`, `Dimensions.*`, `context.color` / `context.textStyle`
- navigation: `context.pushNamed` / `context.pop`; modal — `MaterialSheetRoute` / `MaterialDialogRoute<T>`
- add the route to `modules/<module>/lib/src/router/<module>_router.dart`

Don't use analyze/test during the turn.

Task is taken from the user.

Rules source: `AGENTS.md`. No analyze/test/pub get during a turn (§7).
