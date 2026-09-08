# ui.md — UI, Widgetlar, Tematizatsiya va Style

> **Etalon Sahifa:** `modules/notifications/lib/src/presentation/notifications/notifications_page.dart`
> **Etalon Widget:** `modules/notifications/lib/src/presentation/notifications/widgets/notification_item.dart`
> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

---

## 1. Joylashuv va Tuzilma

UI elementlari va umumiy dizayn tizimi quyidagicha taqsimlanadi:

```
packages/components/lib/src/
├── theme/                            # ThemeColors (context.color), ThemeTextStyles (context.textStyle)
├── utils/dimensions.dart             # kGap*, kPadding*, kRadius*, kBorderRadius*, kShape*
├── loading/                          # CustomCircularProgressIndicator
└── top_snack_bar/                    # TopSnackBar, CustomSnackBar

modules/<module>/lib/src/presentation/<feature>/
├── widgets/                          # Kichik bo'laklarga ajratilgan vidjetlar
└── <feature>_page.dart               # Asosiy sahifa
```

---

## 2. Qat'iy Qoidalar (Non-negotiables)

1. **Material Import Qat'iyan Taqiq:** Hech qachon `package:flutter/material.dart` import qilinmaydi. Har doim `package:material_ui/material_ui.dart` va `package:components/components.dart` import qilinadi.
2. **Bo'shliq va O'lchamlar:** Xom `SizedBox(height: 12)`, `SizedBox(width: 8)` yoki `EdgeInsets.all(16)` yozish taqiqlangan. Faqat `Dimensions.kGap*`, `Dimensions.kPadding*`, `Dimensions.kBorderRadius*` ishlatiladi.
3. **Ranglar va Tipografiya:** Hardcoded `Color(0xFF...)` yoki xom `TextStyle(...)` yozilmaydi. Ranglar — `context.color.*` / `context.colorScheme.*`. Matn stili — `context.textStyle.*` (`ThemeTextStyles`, masalan `defaultW600x16`); rang qo'shish kerak bo'lsa `.copyWith(color: ...)`. `context.textTheme.*` faqat Material tipografiyasi kerak bo'lgan joyda.
4. **setState Intizomi:** `setState` faqat va faqat boshqa hech narsa (BLoC) qayta chizmaydigan lokal tranzit holatlar uchungina (password obscure, local checkbox) ishlatiladi. `BlocBuilder`/`BlocConsumer` qayta chizadigan holatda ortiqcha `setState` taqiqlangan.
5. **Tayyor Komponentlar:** Spinner uchun `CustomCircularProgressIndicator`, asosiy tugma uchun `CustomLoadingButton`, xabarnoma uchun `showTopSnackBar` ishlatiladi.

---

## 3. Standart Kod Skeletlari va Namunalar

### A. O'lchamlar (Dimensions)
```dart
// Bo'shliqlar (Gap widgeti — Column/Row children ichiga qo'yiladi):
Dimensions.kGap2  Dimensions.kGap3  Dimensions.kGap4  Dimensions.kGap6  Dimensions.kGap8
Dimensions.kGap12 Dimensions.kGap16 Dimensions.kGap20 Dimensions.kGap24 Dimensions.kGap32 Dimensions.kGap40

// Paddinglar (EdgeInsets):
Dimensions.kPaddingAll4  Dimensions.kPaddingAll6  Dimensions.kPaddingAll8
Dimensions.kPaddingAll10 Dimensions.kPaddingAll12 Dimensions.kPaddingAll16 Dimensions.kPaddingAll24
Dimensions.kPaddingHor4  Dimensions.kPaddingHor6  Dimensions.kPaddingHor10
Dimensions.kPaddingHor12 Dimensions.kPaddingHor16 Dimensions.kPaddingVertical16
Dimensions.kPaddingHor16Ver4 Dimensions.kPaddingHor16Ver8 Dimensions.kPaddingHor16Ver12
Dimensions.kPaddingHor12Ver8 Dimensions.kPaddingHor8Ver2 Dimensions.kPaddingHor8Ver4

// Radius (Radius tipi — faqat BorderRadius.only/vertical ichida ishlatiladi):
Dimensions.kRadius  Dimensions.kRadius8  Dimensions.kRadius12

// BorderRadius (widget `borderRadius:` va BoxDecoration uchun — SHUNI ishlat):
Dimensions.kBorderRadius2  Dimensions.kBorderRadius4  Dimensions.kBorderRadius6
Dimensions.kBorderRadius8  Dimensions.kBorderRadius12 Dimensions.kBorderRadius16
Dimensions.kBorderRadius24 Dimensions.kBorderRadius48 Dimensions.kBorderRadius64
Dimensions.kBorderTopRadius24

// Shape (Card, BottomSheet, Dialog uchun):
Dimensions.kShapeZero Dimensions.kShapeTop8 Dimensions.kShapeBottom8 Dimensions.kShapeAll8
```

> ⚠️ **Radius ≠ BorderRadius.** `borderRadius:` parametriga `Dimensions.kRadius12` berish — tip xatosi
> (`kRadius12` bu `Radius`). Doim `Dimensions.kBorderRadius12` ishlat.
> Yagona istisno: `Dimensions.kRadius20` — nomi `kRadius*` bo'lsa ham tipi `BorderRadius`.

### B. Ranglar va Shriftlar (Theme Tokens)
```dart
// Ranglar
context.color.primary
context.color.background
context.color.backgroundSecondary
context.color.onBackground
context.color.textPrimary
context.color.textSecondary
context.colorScheme.surface
context.colorScheme.error

// Tipografiya — ASOSIY manba: context.textStyle (ThemeTextStyles), nomi `defaultW<weight>x<size>`
context.textStyle.defaultW400x12  context.textStyle.defaultW400x14  context.textStyle.defaultW400x16
context.textStyle.defaultW500x12  context.textStyle.defaultW500x13  context.textStyle.defaultW500x14
context.textStyle.defaultW500x16  context.textStyle.defaultW500x18  context.textStyle.defaultW500x24
context.textStyle.defaultW600x14  context.textStyle.defaultW600x16  context.textStyle.defaultW600x18
context.textStyle.defaultW600x20  context.textStyle.defaultW600x24
context.textStyle.defaultW700x12  context.textStyle.defaultW700x14  context.textStyle.defaultW700x16
context.textStyle.defaultW700x18  context.textStyle.defaultW700x24

// Rang bilan birga: har doim .copyWith(), xom TextStyle(...) emas
context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary)

// context.textTheme.* — faqat Material tipografiya kerak bo'lganda (headlineSmall, titleLarge, bodyMedium ...)
```

### C. Standart Vidjet Namuna
```dart
import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';

class NotificationItem extends StatelessWidget {
  const new({required this.args, super.key});

  final NotificationItemArgs args;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: args.onTap,
    borderRadius: Dimensions.kBorderRadius12,
    child: Container(
      padding: Dimensions.kPaddingAll16,
      decoration: BoxDecoration(
        color: args.isRead ? context.color.background : context.color.backgroundSecondary,
        borderRadius: Dimensions.kBorderRadius12,
        border: Border.all(color: context.color.onBackground),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_outlined, color: context.color.primary),
          Dimensions.kGap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(args.title, style: context.textStyle.defaultW600x16),
                Dimensions.kGap4,
                Text(
                  args.message,
                  style: context.textStyle.defaultW400x14.copyWith(color: context.color.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
```

---

## 4. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ `import 'package:flutter/material.dart'` yozish (`arch-guard` da xatolik beradi).
- ❌ Xom `SizedBox(height: 16)` ishlatish (standart: `Dimensions.kGap16`).
- ❌ Hardcoded rang berish: `color: Colors.white` (standart: `context.color.background` yoki `context.colorScheme.surface`).
- ❌ `BlocConsumer.listener` ichida `state is LoadedState` bo'lganda ortiqcha `setState` chaqirish.

---

## 5. Tekshiruv Ro'yxati (Checklist)

- [ ] `package:material_ui/material_ui.dart` import qilingan (flutter/material.dart yo'q).
- [ ] Barcha bo'shliqlar `Dimensions.kGap*` va paddinglar `Dimensions.kPadding*` orqali berilgan.
- [ ] Ranglar `context.color.*`, matn stili `context.textStyle.*` orqali olingan; xom `TextStyle(...)` yo'q.
- [ ] `borderRadius:` ga `Dimensions.kBorderRadius*` berilgan (`kRadius*` emas).
- [ ] Ortiqcha `setState` yo'q, faqat lokal tranzit holatlar uchun ishlatilgan.
