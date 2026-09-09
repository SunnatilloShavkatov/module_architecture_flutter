# /test

Etalon: `modules/notifications/test/` — aggregator `notifications_test.dart`
+ `test/src/**` oynasi `lib/src/**` bilan aynan mos.
Qoida: `docs/rules/testing.md`.

Talab:
- fayl nomi `<target>_test.dart`, joyi `test/src/<lib dagi yo'l>/`
- yangi fayl aggregator (`<module>_test.dart`) ga `import ... as <name>_test` + `main()` bilan ulanadi
- mock'lar mocktail: `class MockX extends Mock implements X {}`
- bloc testi `blocTest` bilan; `expect` — sealed state turlari ro'yxati
- `setUpAll` da `registerFallbackValue` kerak bo'lsa

Testni turn ichida ishga tushirma (`AGENTS.md` §7) — CI va pre-commit qiladi.

Topshiriq foydalanuvchidan olinadi.

Qoidalar manbasi: `AGENTS.md`. Turn ichida analyze/test/pub get yo'q (§7).
