---
description: Write tests for a module (mocktail + bloc_test)
argument-hint: <module> <target>
allowed-tools: Read, Edit, Write, Grep, Glob
---

Reference: `modules/notifications/test/` — aggregator `notifications_test.dart`
+ `test/src/**` mirrors `lib/src/**` exactly.
Rules: `docs/rules/testing.md`.

Requirements:
- file name `<target>_test.dart`, location `test/src/<path from lib>/`
- new file is wired into the aggregator (`<module>_test.dart`) with `import ... as <name>_test` + in `main()`
- mocks via mocktail: `class MockX extends Mock implements X {}`
- bloc test uses `blocTest`; `expect` — list of sealed state types
- `registerFallbackValue` in `setUpAll` when needed

Don't run tests during the turn (`AGENTS.md` §7) — CI and pre-commit do that.

Task: $ARGUMENTS
