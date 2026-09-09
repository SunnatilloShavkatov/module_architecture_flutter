# packages.md — `packages/*` (umumiy paketlar) ustida ish

> Etalon: `packages/components/lib/src/buttons/custom_loading_button.dart` (komponent),
> `packages/components/lib/src/theme/theme_colors.dart` (rang), `packages/core/lib/src/constants/` (konstanta).

> Oddiy topshiriq uchun shu blok yetarli — pastini faqat yangi qatlam qo'shayotganda o'qi.
>
> ### Qattiq qoidalar (TL;DR)
> - **`arch-guard` bu yerda qisman ishlaydi**: import qoidalari, `print`, `MediaQuery.of`, `const new(...)`,
>   `fromJson`, import tartibi, barrel alfaviti, modul importi — tekshiriladi. `Theme.of`, `EdgeInsets`,
>   `Navigator`, oraliq `SizedBox` — **tekshirilmaydi**, chunki `context.color`, `Dimensions` va page
>   route'lar aynan shu API'lar ustiga quriladi.
> - Har yangi public fayl paket **barrel**iga export qilinadi (`components.dart`, `core.dart`, ...).
>   Export qilinmagan fayl — modul uchun mavjud emas.
> - `packages/*` hech qachon `modules/*` ni import qilmaydi. `core`, `components`, `navigation`,
>   `platform_methods` bir-biriga ham bog'lanmaydi. Yagona istisno — `merge_dependencies`.
> - `package:flutter/material.dart` bu yerda ham taqiq — `material_ui`.
> - §5 taqiqlar (`AGENTS.md`) va §6 nomlash paketlarda ham amal qiladi.

## 1. Qaysi paketga qo'shiladi

| Nima yozyapsan | Paket |
|---|---|
| widget, tugma, sheet, animatsiya, `Dimensions`, tema | `components` |
| entity, `Either`/`Failure`, usecase base, network, l10n, `Constants`, DI interfeys | `core` |
| `Routes`, custom page route, umumiy args | `navigation` |
| native kanal | `platform_methods` |
| container ro'yxati, app yig'ish | `merge_dependencies` |

Ikkilansang: modul ichida qolsin. Umumiy paketga faqat **ikkinchi** iste'molchi paydo bo'lganda ko'chir.

## 2. Yangi fayl qo'shish — 3 qadam

1. Faylni to'g'ri kategoriya papkasiga qo'y: `packages/components/lib/src/<kategoriya>/<name>.dart`
   (mavjud papkalardan tanla — `buttons/`, `inputs/`, `loading/`, `theme/`, `utils/`, `extension/`, ...).
2. Barrelga export qo'sh, alfavit tartibini buzmasdan.
3. Xulq-atvori bor kod (logika, parsing, holat) uchun test yoz:
   `packages/<paket>/test/src/<xuddi shu yo'l>_test.dart`.

Nisbiy import bu yerda ham yo'q — `package:` bilan yoz.

## 3. Yangi rang — 6 ta joy

`ThemeColors` — `ThemeExtension<ThemeColors>`, `part of 'themes.dart'`. Bitta maydon qo'shish
`packages/components/lib/src/theme/theme_colors.dart` ning 6 joyiga tegadi:

1. `AppPalette` ga xom rang (`app_palette.dart`)
2. `ThemeColors` maydoni: `final Color xxx;`
3. konstruktor: `required this.xxx,`
4. `static const ThemeColors light = ThemeColors(... xxx: AppPalette.a ...)`
5. `static const ThemeColors dark = ThemeColors(... xxx: AppPalette.b ...)`
6. `copyWith` va `lerp` — ikkalasida ham yangi maydon

Ishlatish: `context.color.xxx`.

## 4. Yangi `Dimensions` konstantasi

`packages/components/lib/src/utils/dimensions.dart`. Avval qidir, keyin qo'sh; nomlash va tanlov
qoidasi — [`ui.md`](ui.md). Bir marta ishlatiladigan qiymat uchun konstanta qo'shma.

## 5. Yangi konstanta / kalit

| Nima | Joy |
|---|---|
| local storage kaliti | `core/lib/src/constants/storage_keys.dart` |
| umumiy limit/konstanta | `core/lib/src/constants/constants.dart` |
| modullararo entity | `core/lib/src/entities/` |
| l10n kaliti | `core/lib/src/l10n/*.arb` — [`l10n.md`](l10n.md) |

## 6. Modul ↔ paket chegarasi

- Modul paketning faqat barrelini ko'radi: `package:core/core.dart`. `src/` ga kirish — taqiq (`arch-guard` modul tomonda ushlaydi).
- Paketga modulga xos nom, matn yoki biznes qoida kirmaydi.
- Paket API sini o'zgartirsang, iste'molchini `rg` bilan top va shu turn'da tuzat.

## 7. Tekshiruv

- [ ] fayl to'g'ri paketda va kategoriya papkasida
- [ ] barrelga export qo'shilgan (alfavit)
- [ ] `package:` importlar, `flutter/material` yo'q
- [ ] rang qo'shilgan bo'lsa — 6 ta joy ham
- [ ] paket boshqa paketga / modulga bog'lanmagan
