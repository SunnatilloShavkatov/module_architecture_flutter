# Claude Code Setup Spec

Ushbu hujjat loyihaning AI agentlar (Claude Code, Gemini, Antigravity) uchun sozlanishi, yagona SDK standarti va tezkor ishlash tartibini belgilaydi.

---

## 1. Yagona SDK Standarti (Single Unified SDK)

Loyihada **FVM ishlatilmaydi**. Ildizdagi (root) yagona Flutter va Dart SDK butun loyiha bo'ylab qo'llaniladi.

| Talab           | Versiya                                  | Izoh                                                                  |
|-----------------|------------------------------------------|-----------------------------------------------------------------------|
| **Flutter SDK** | `>=3.47.0` (amalda `Flutter 3.47.2`)     | Barcha `pubspec.yaml` larda bir xil                                   |
| **Dart SDK**    | `>=3.13.0 <4.0.0` (amalda `Dart 3.13.2`) | Dart 3.47 konstruktor shorthandi (`const new()`) qo'llab-quvvatlanadi |
| **FVM holati**  | **Kerak emas**                           | Tizimdagi Flutter SDK to'g'ridan-to'g'ri ishlatiladi                  |

Barcha modullar (`modules/*`), paketlar (`packages/*`) va ilova ildizidagi `pubspec.yaml` aynan shu yagona SDK versiyasiga sozlangan:

```yaml
environment:
  sdk: ">=3.13.0 <4.0.0"
  flutter: ">=3.47.0"
```

Barcha skriptlar (`scripts/verify.sh`, `scripts/quick_check.sh` va h.k.) avtomatik ravishda tizimdagi Flutter SDK yo'lini aniqlaydi.

---

## 2. Mavjud Qoidalar va Tuzilma (File Layout)

| Fayl / Papka                                                    | Maqsadi                                                                                                                                             | Token samaradorligi                            |
|-----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------|
| [`AGENTS.md`](../AGENTS.md)                                     | Asosiy qoidalar, qattiq taqiqlar jadvali va lokal etalonlar xaritasi                                                                                             | ~180 qator (har sessiyada avtomatik yuklanadi) |
| [`CLAUDE.md`](../CLAUDE.md)                                     | `AGENTS.md` va `docs/rules/` ga yo'naltiruvchi ko'rsatkich                                                                                          | 14 qator (ortiqcha token sarflamaydi)          |
| [`GEMINI.md`](../GEMINI.md)                                     | Gemini/Antigravity uchun yo'naltiruvchi ko'rsatkich                                                                                                 | 14 qator                                       |
| [`docs/rules/`](rules/)                                         | Mavzulashtirilgan 9 ta aniq qoida fayli (`module.md`, `domain.md`, `data-api.md`, `bloc.md`, `page-mixin.md`, `navigation.md`, `ui.md`, `l10n.md`, `testing.md`) | Kerak bo'lgandagina ochiladi (~1-2 KB)         |
| [`.claude/hooks/arch-guard.sh`](../.claude/hooks/arch-guard.sh) | Modullararo noqonuniy to'g'ridan-to'g'ri importlarni tekshiruvchi hook                                                                              | Avtomatlashtirilgan tekshiruv                  |

---

## 3. Ishlatiladigan Tayyor Skriptlar (Fast Developer Tools)

AI agent uchun har bir ish yakunida vaqtni tejovchi tayyor skriptlar yaratilgan:

### 1. `scripts/verify.sh` — Yagona Tezkor Yakunlash Darvozasi (<10s)
Har qanday kod yozish ishi tugagach yurgaziladi:
```bash
./scripts/verify.sh
```
- Faqat o'zgargan fayllarni `arch-guard`, `dart format`, `dart analyze` va o'zgargan modulning testidan o'tkazadi.
- 5–10 soniyada tugaydi, terminalda atigi 3–4 qator qisqa hisobot chiqaradi.
- Katta arxitekturaviy o'zgarish bo'lganda: `./scripts/verify.sh --all`

### 2. `scripts/create_module.sh <name>` — Yangi Modul Generatori (1s)
Yangi modulning 6 qatlamini (18 fayl), Dart 3.47 shorthand, router, DI va smoke-test aggregatorini 1 sekundda yaratadi:
```bash
./scripts/create_module.sh orders
```

### 3. `scripts/test_module.sh <name>` — Muayyan Modul Testi (~3s)
Butun loyihani testlash o'rniga faqat kerakli modulni tezkor tekshiradi:
```bash
./scripts/test_module.sh notifications
```

### 4. `scripts/quick_check.sh` — Tezkor Format va Analiz (~3s)
Faqat o'zgargan fayllarni `dart format` va `dart analyze` qiladi.

---

## 4. Qat'iy Taqiqlar (Guardrails)

1. **APK / iOS Build Qat'iyan Taqiqlangan:** Agent hech qachon `flutter build apk`, `flutter build ios` yoki `gradlew` buyruqlarini bajarmaydi. Bu 3–5 daqiqa vaqt oladi. Build faqat foydalanuvchining o'ziga topshiriladi.
2. **Uzoq kutishlar taqiqlangan:** Skriptlar 30–60 soniyadan oshiq vaqt olmasligi shart. Shu sababli `flutter analyze` o'rniga faqat o'zgargan fayllarda `dart analyze $FILES` ishlatiladi.
3. **Modullararo To'g'ridan-to'g'ri Bog'liqlik Taqiqlangan:** Modullar bir-birini import qilmaydi (`arch-guard` qoidasi). Aloqa faqat `core` dagi interactor, args yoki DI orqali amalga oshiriladi.
4. **Material.dart Import Taqiqlangan:** `package:flutter/material.dart` o'rniga faqat `package:material_ui/material_ui.dart` va `package:components/components.dart` ishlatiladi.
5. **Xom SizedBox Taqiqlangan:** Faqat `Dimensions.kGap*`, `Dimensions.kPadding*`, `Dimensions.kRadius*` ishlatiladi.

---

## 5. Yangi Modul yoki Loyiha Ochish Qadamlari

1. Tizimdagi SDK ni tekshiring:
   ```bash
   flutter --version   # >= 3.47.0 bo'lishi kerak
   ```
2. Yangi modul kerak bo'lsa:
   ```bash
   ./scripts/create_module.sh <module_name>
   ```
3. O'zgarishlarni tekshirish uchun:
   ```bash
   ./scripts/verify.sh
   ```
