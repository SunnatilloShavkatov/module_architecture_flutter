# Modular Architecture Documentation & Rules

> Ushbu papka arxitektura qoidalari, standartlar va AI agentlari (Antigravity, Claude Code, Cursor) uchun to'liq yo'riqnomalarni o'z ichiga oladi.
> Barcha javoblar va tushuntirishlar **O'zbek tilida**, kod, identifikatorlar va izohlar esa **Ingliz tilida** yoziladi (`AGENTS.md` §0).

---

## 📚 Qoidalar Xaritasi (Rules Map)

Loyiha Clean Architecture va Feature-First tamoyillariga asoslangan bo'lib, har bir qatlam va jihat uchun alohida standart qoida fayli ishlab chiqilgan:

| # | Mavzu | Qoida Fayli | Loyihadagi Haqiqiy Etalon |
|---|---|---|---|
| 1 | **Modul Tuzilishi** | [`docs/rules/module.md`](rules/module.md) | `modules/notifications/lib/src/notifications_container.dart` |
| 2 | **Domain Qatlami** | [`docs/rules/domain.md`](rules/domain.md) | `modules/notifications/lib/src/domain/` |
| 3 | **Data & API Qatlami** | [`docs/rules/data-api.md`](rules/data-api.md) | `modules/notifications/lib/src/data/` |
| 4 | **BLoC & State** | [`docs/rules/bloc.md`](rules/bloc.md) | `modules/notifications/lib/src/presentation/notifications/bloc/` |
| 5 | **Sahifa & Mixin** | [`docs/rules/page-mixin.md`](rules/page-mixin.md) | `modules/notifications/lib/src/presentation/notifications/` |
| 6 | **Navigatsiya & Router** | [`docs/rules/navigation.md`](rules/navigation.md) | `modules/notifications/lib/src/router/notifications_router.dart` |
| 7 | **UI, Dimensions & Theme** | [`docs/rules/ui.md`](rules/ui.md) | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart` |
| 8 | **Lokalizatsiya (l10n)** | [`docs/rules/l10n.md`](rules/l10n.md) | `packages/core/lib/src/l10n/` & `modules/auth/lib/src/presentation/login/` |
| 9 | **Testlash (Unit & BLoC)** | [`docs/rules/testing.md`](rules/testing.md) | `modules/notifications/test/notifications_test.dart` |

---

## 🛠️ Muhit va Sozlamalar

- [`docs/claude_code_setup.md`](claude_code_setup.md) — Claude Code, Antigravity va boshqa AI agentlar uchun muhit sozlamalari, buyruqlar va xavfsizlik chegaralari.

---

## ⚡ Tezkor Skriptlar

AI Agentlari va dasturchilar uchun token-tejamkor va tezkor (<10s) skriptlar:

- `./scripts/verify.sh` — Tezkor verifikatsiya darvozasi (faqat o'zgargan fayllar va modul testlarini tekshiradi).
- `./scripts/verify.sh --all` — To'liq verifikatsiya: arch-guard (butun loyiha) + guard/qoida selftest + `dart format` + `dart analyze` + **barcha** modul va paket testlari (ro'yxat dinamik — yangi modul o'zi qo'shiladi).
- `./scripts/quick_check.sh` — Format va analizni tezkor tekshirish (~3s).
- `./scripts/test_module.sh <name>` — Muayyan modul yoki paket testlarini yurgazish (`./scripts/test_module.sh notifications`, `./scripts/test_module.sh core`). Argumentsiz — hammasi.
- `./scripts/create_module.sh <name>` — Yangi modulning 6 qatlami (18 fayl) + container/router/DI va smoke-test aggregatorini yaratadi. To'liq test to'plamini o'zing yozasan (`docs/rules/testing.md`).
