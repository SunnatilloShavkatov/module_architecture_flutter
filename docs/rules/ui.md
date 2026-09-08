# ui.md — UI, Widgetlar, Tematizatsiya va Style

> Etalon Sahifa: `modules/notifications/lib/src/presentation/notifications/notifications_page.dart`
> Etalon Widget: `modules/notifications/lib/src/presentation/notifications/widgets/notification_item.dart`
> Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).

## 1. Import qoidasi (Non-negotiable)

Hech qachon `package:flutter/material.dart` import qilinmaydi — u taqiqlangan. Har doim `material_ui` import qilinadi:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:components/components.dart';
```

## 2. Bo'shliqlar va O'lchamlar (Spacing & Dimensions)

Hech qachon xom `SizedBox(height: 12)`, `SizedBox(width: 8)` yoki `EdgeInsets.all(16)` yozilmaydi.
Buning o'rniga `packages/components/lib/src/utils/dimensions.dart` dagi tayyor tokenlar ishlatiladi:

```dart
// Bo'shliqlar (Gap):
Dimensions.kGap4, Dimensions.kGap8, Dimensions.kGap12, Dimensions.kGap16, Dimensions.kGap20, Dimensions.kGap24

// Paddinglar:
Dimensions.kPaddingAll8, Dimensions.kPaddingAll16, Dimensions.kPaddingAll24
Dimensions.kPaddingHor16, Dimensions.kPaddingVer12

// Radiuslar:
Dimensions.kRadius8, Dimensions.kRadius12, Dimensions.kRadius16, Dimensions.kRadius20, Dimensions.kRadiusCircular
```

## 3. Ranglar va Matn Stili (Theme Tokens)

Rang yoki shrift parametrlarini taxmin qilib to'qimang. `components` eksport qiladigan kengaytmalar:

```dart
// Ranglar (ThemeColors & ColorScheme)
context.color.primary
context.color.background
context.color.backgroundSecondary
context.color.onBackground
context.color.textPrimary
context.color.textSecondary
context.colorScheme.surface
context.colorScheme.error

// Tipografiya (TextTheme)
context.textTheme.headlineSmall
context.textTheme.titleLarge
context.textTheme.titleMedium
context.textTheme.bodyMedium
context.textTheme.bodySmall
```

## 4. Tayyor Komponentlar (Design System Components)

Qayta g'ildirak ixtiro qilinmaydi. `components` paketida mavjud bo'lgan asosiy vidjetlar:

- `CustomLoadingButton` — holatiga ko'ra spinner ko'rsatuvchi asosiy tugma (`isLoading: state is LoadingState`).
- `CustomCircularProgressIndicator` — adaptiv yuklanish indikatori.
- `SafeAreaWithMinimum` — chekka ekranlar uchun standart paddingli SafeArea (`minimum: Dimensions.kPaddingAll16`).
- `showTopSnackBar(...)` — xabarnoma va xatolik ko'rsatish paneli (`packages/components/lib/src/top_snack_bar/`).

## 5. setState intizomi

`setState` faqat va faqat **boshqa hech narsa qayta chizmaydigan lokal tranzit holatlar** uchungina ishlatiladi:
- Parol yashirish/ko'rsatish (`_isPasswordObscured = !_isPasswordObscured`)
- Checkbox belgisi (`_rememberMe = isChecked`)

`BlocConsumer` yoki `BlocBuilder` allaqachon qayta chizadigan joyda (masalan, `state is FailureState` da) ikkinchi marta `setState` chaqirish — **qat'iyan taqiqlangan** (redundant rebuild).

## 6. Tekshiruv ro'yxati

- [ ] `package:material_ui/material_ui.dart` import qilingan (flutter/material.dart yo'q).
- [ ] Gap va paddinglar `Dimensions.kGap*`, `Dimensions.kPadding*` orqali berilgan, xom `SizedBox(height/width)` yo'q.
- [ ] Ranglar `context.color.*` va `context.colorScheme.*` orqali olingan.
- [ ] Matn stili `context.textTheme.*` orqali olingan.
- [ ] Ortiqcha `setState` yo'q, faqat lokal tranzit holatlar uchun.
