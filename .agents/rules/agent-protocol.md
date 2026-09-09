# Agent ishlash protokoli (Antigravity / avtonom agentlar)

> Qoidalar manbasi: `AGENTS.md`. Bu fayl faqat **agentning o'zini tutishi** haqida.
> Antigravity `.agents/rules/` ni avtomatik yuklaydi.

## 1. Terminal (`run_command`)

- Hech qachon `cd` ishlatma. Har doim `Cwd` parametrini ber.
- Standart sandbox: `BypassSandbox: false`. Faqat tarmoq kerak bo'lsa bypass so'ra.
- Buyruqlarni `&&` bilan uzun zanjirlama — prefix-matchable, bitta maqsadli buyruq.
- **Taqiqlangan buyruqlar (turn ichida):** `flutter analyze`, `dart analyze`, `flutter test`,
  `flutter pub get`, `flutter clean`, `flutter build`, `dart format ./`, `dart fix --apply`.
  Sifat: guard → pre-commit → CI (`AGENTS.md` §7). Kerak bo'lsa:
  `bash scripts/arch_guard_scan.sh --changed` (~1 s).

## 2. Fayl tahrirlash (`replace_file_content`)

- Tahrirdan oldin `view_file` — qator raqami va indentatsiyani tekshir.
- Bitta faylga parallel bir nechta tahrir chaqiruvi qilma.
- `write_to_file` bilan mavjud katta faylni bosib ketma — faqat kerakli qismni almashtir.

## 3. Rejalashtirish

- Bug fix, l10n, UI styling, bitta fayl refaktori → **reja tuzma**, to'g'ridan-to'g'ri bajar.
- Reja faqat: yangi modul yoki katta arxitektura refaktoringi uchun.

## 4. Har tahrirdan keyin (o'zing tekshir, buyruqsiz)

- Import'ga `package:flutter/material.dart` kirib qolmadimi (faqat `material_ui`).
- `modules/*` dan boshqa modulga import yo'q.
- Konstruktor `const new(...)` shaklida.
- Matn `context.l10n.*`, `BlocBuilder` da `buildWhen` bor.

## 5. Token intizomi

- Bir faylni ikki marta o'qima; `rg` bilan qidir.
- Uzun faylni to'liq emas, kerakli oralig'ini o'qi.
- Javob: nima qilinganini 3–5 qator + tegilgan fayllar. Reja/variant ro'yxati yo'q.
