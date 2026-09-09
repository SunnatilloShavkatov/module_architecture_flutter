# CLAUDE.md

@AGENTS.md

## Turn siyosati

- Turn ichida **hech qachon**: `flutter analyze`, `flutter test`, `flutter pub get`,
  `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.
  Sifat: PostToolUse guard (har edit) → Stop hook (format + scan) → pre-commit → CI (to'liq).
- Guard xabari kelsa: faqat ko'rsatilgan qatorni tuzat, faylni qayta o'qima.
- Bir faylni ikki marta o'qima. Qidiruv: `rg` — `find` / `ls -R` emas.
- Reja va variantlar ro'yxati yozma — ish qil, 3–5 qator xulosa + tegilgan fayllar ro'yxati.

## Tayyor buyruqlar

`/bloc`, `/page`, `/endpoint`, `/l10n`, `/module`, `/test`, `/guard` — `.claude/commands/`.
Har biri kerakli etalon + rules faylini o'zi ko'rsatadi, ortiqcha fayl o'qilmaydi.

**Javob o'zbek tilida. Kod, kommentariya, commit va PR matni ingliz tilida.**
