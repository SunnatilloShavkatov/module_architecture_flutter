# page-mixin.md — Sahifa, Mixin, State Egaligi va Barcha Senariylar

> **Qoida:** Javob o'zbekcha, kod inglizcha (`AGENTS.md` §0).  
> **Muhim:** Paginatsiyali ro'yxat — yagona yechim emas! Loyihada turli xil ehtiyojlar uchun turli xil Page + Mixin yechimlari mavjud bo'lib, har birining o'z o'rni va loyihada aniq etaloni bor.

---

## 1. Loyihadagi Page + Mixin Senariylari Xaritasi

Quyidagi jadvalda har bir senariy turi, unda nimalar ishlatilishi va loyihadagi aniq fayl manzillari keltirilgan:

| # | Senariy Turi | Tavsifi va Ishlatiladigan vositalar | Loyihadagi Aniq Etalon Manzili |
|---|---|---|---|
| 1 | **Paginatsiyali Ro'yxat (Infinite List)** | `ScrollController`, Set-union deduplication, `buildWhen`, Sheet & Dialog router chaqiruvi | `modules/notifications/lib/src/presentation/notifications/notifications_page.dart`<br>`modules/notifications/lib/src/presentation/notifications/mixin/notifications_mixin.dart` |
| 2 | **Forma va Autentifikatsiya (Form & Auth)** | `TextEditingController`, `FormKey`, password obscure toggle (`setState`), validatsiya, submit | `modules/auth/lib/src/presentation/login/login_page.dart`<br>`modules/auth/lib/src/presentation/login/mixin/login_mixin.dart` |
| 3 | **OTP / Tasdiqlash Kiritish (OTP & Verification)** | PIN / SMS controller, tashqi havola ochish (`launchUrl`), xatolik ko'rsatish, qayta yuborish | `modules/auth/lib/src/presentation/otp_login/otp_login_page.dart`<br>`modules/auth/lib/src/presentation/otp_login/mixin/otp_login_mixin.dart` |
| 4 | **Forma Tahrirlash va Natija Qaytarish (Edit & Return)** | `widget.args` dan boshlang'ich qiymat olish, validatsiya, mutatsiya va `context.pop(true)` | `modules/profile/lib/src/presentation/edit_profile/edit_profile_page.dart`<br>`modules/profile/lib/src/presentation/edit_profile/mixin/edit_profile_mixin.dart` |
| 5 | **Moliya / Karta Kiritish (Input Masking)** | Karta raqami/muddati, brand aniqlash (Visa/Mastercard), tozalash va saqlash | `modules/payments/lib/src/presentation/add_card/add_card_page.dart`<br>`modules/payments/lib/src/presentation/add_card/mixin/add_card_mixin.dart` |
| 6 | **Dashboard va Ko'p Bo'limli Ekran (Dashboard & Refresh)** | Murakkab entity'lar (kategoriya, biznes, bandlik), refresh hodisasi, bo'limlararo boshqaruv | `modules/home/lib/src/presentation/main/home_page.dart`<br>`modules/home/lib/src/presentation/main/mixin/home_mixin.dart` |
| 7 | **Ilova Bootstrap / Splash (Lifecycle Routing)** | BLoC siz yoki yengil holat, `initState` da tokenni tekshirish va `pushReplacementNamed` | `modules/initial/lib/src/presentation/splash/splash_page.dart`<br>`modules/initial/lib/src/presentation/splash/mixin/splash_mixin.dart` |
| 8 | **Asosiy Shell / Tablar (Navigation Shell)** | `StatefulNavigationShell` orqali tablar almashinuvi (`goBranch(index)`), bottom bar | `modules/main/lib/src/presentation/main/main_page.dart`<br>`modules/main/lib/src/presentation/main/mixin/main_mixin.dart` |
| 9 | **Statik va Tizim Ekranlari (Static / Fallbacks)** | BLoC talab qilinmaydigan xatoliklar, 404, internet uzilishi, qayta urinish tugmasi | `modules/system/lib/src/presentation/not_found/not_found_page.dart`<br>`modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart` |

---

## 2. Asosiy Arxitektura Qoidalari (Non-negotiables)

Barcha senariylar uchun umumiy bo'lgan temir qoidalar:

1. **BLoC — Stateless dvigatel:** BLoC ichida hech qachon ro'yxat, sahifa raqami, matnli controller yoki boolean flag saqlanmaydi (`List _items = []`, `int _page = 1` qat'iyan man etiladi!).
2. **Mixin — Yagona ma'lumot egasi (Single Source of Truth):** Sahifaning barcha o'zgaruvchi holatlari (ro'yxatlar, kontrollerlar, lokal tanlovlar, filtrlar) faqat va faqat sahifaning **Mixin**'ida yashaydi.
3. **4 Bosqichli Bir Tomonlama Oqim:**
   ```
   1. Mixin metodi / listener ──➔ bloc.add(Event)
   2. BLoC handler            ──➔ emit(kichik State)
   3. BlocListener            ──➔ _handleStates ichida mixin fieldini o'zgartiradi
   4. BlocBuilder(buildWhen)   ──➔ mixin getter/fieldlarini o'qib UI ni yangilaydi
   ```
4. **`part` va `part of`:** Mixin doimo `part of '../<feature>_page.dart';` shaklida bo'ladi va sahifaga `part 'mixin/<feature>_mixin.dart';` orqali ulanadi. Alohida import qilinmaydi.
5. **Dastlabki Event sahifaning `initState` ida:** Agar ekran ochilganda BLoC'ga dastlabki event yuborilishi kerak bo'lsa, u Page'ning `initState` ida yuboriladi, mixin'da emas.
6. **Resurslarni Tozalash (Dispose):** Barcha `TextEditingController`, `ScrollController`, `FocusNode` va listenerlar `dispose()` da xotiradan tozalanishi shart.

---

## 3. `setState` Qachon Ishlatiladi va Qachon Taqiq?

Field **qayerda o'qilishiga** va o'zgarish **qayerdan kelishiga** qarab belgilanadi:

| Holat | `setState` | Sabab |
|---|---|---|
| O'zgarish `BlocBuilder` ichidagi widgetni yangilashi kerak va `buildWhen` kelayotgan state'ni o'tkazadi | **TAQIQLANGAN ❌** | `BlocBuilder` o'zi shu emissiyadan qayta chiziladi. Qo'shimcha `setState` keraksiz ikkinchi rebuild beradi. |
| Sof lokal UI holat (masalan: parolni ko'rsatish/yashirish `_isPasswordObscured`, checkbox `_rememberMe`) | **KERAK ✅** | Bu holatlar BLoC'ga aloqasiz, faqat lokal widget daraxtini yangilash uchun. |
| BLoC event yuborilmagan validation xatoligi (masalan: OTP bo'sh qolganda `_errorMessage` ko'rsatish) | **KERAK ✅** | Hech qanday BLoC state emit bo'lmaydi, shuning uchun faqat `setState` orqali ko'rinadi. |
| Dialog yoki Sheet qaytargan natijani lokal o'zlashtirish (`mounted` tekshiruvi bilan) | **KERAK ✅** | Modal yopilgach, sahifadagi filtr qiymatini yangilash uchun. |
| Async (`await`) dan keyin `context` yoki `setState` ga tegish | **`if (!mounted) return;`** | Sahifa yopilib ketgan bo'lsa xotira oqishi yoki context buzilishini oldini oladi. |

---

## 4. Senariylar Bo'yicha Haqiqiy Namunalar

### Senariy 1: Paginatsiyali Ro'yxat (Infinite List & Filters)
**Loyihadagi Manzil:**
- Sahifa: `modules/notifications/lib/src/presentation/notifications/notifications_page.dart`
- Mixin: `modules/notifications/lib/src/presentation/notifications/mixin/notifications_mixin.dart`

**Mantiq:**
- `ScrollController` pastga yetganda `_isLastPage` holatini tekshirib, `GetPaginatedNotificationsEvent` yuboradi.
- Set-union deduplikatsiya: `_notifications = {..._notifications, ...state.notifications}.toList();`.
- Sahifa tugaganini tekshirish: `state.notifications.length < Constants.defaultPageLimit`.
- Filtrlangan ro'yxat — doim **getter**: `List<NotificationEntity> get _filteredNotifications => ...`.
- Filtr modalini ochish va natijani qabul qilish `context.pushNamed(Routes.xxx)` orqali bo'ladi.

```dart
// Mixin qismi:
part of '../notifications_page.dart';

mixin NotificationsMixin on State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();
  List<NotificationEntity> _notifications = [];
  int _page = 1;
  bool _isLastPage = false;

  void _handleStates(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoadedState) {
      _notifications = state.notifications;
      if (state.notifications.length < Constants.defaultPageLimit) {
        _isLastPage = true;
      } else {
        _page++;
      }
    } else if (state is NotificationsPaginationLoadedState) {
      _notifications = {..._notifications, ...state.notifications}.toList(); // Set-union
      if (state.notifications.length < Constants.defaultPageLimit) {
        _isLastPage = true;
      } else {
        _page++;
      }
    } else if (state is NotificationsFailureState) {
      showErrorMessage(context, message: state.message);
    }
  }

  void _scrollListener() {
    if (_isLastPage || _notifications.isEmpty) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      bloc.add(GetPaginatedNotificationsEvent(page: _page));
    }
  }

  void _disposeMixin() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
  }

  NotificationsBloc get bloc => context.read<NotificationsBloc>();
}
```

---

### Senariy 2: Forma, Validatsiya va Autentifikatsiya (Form & Auth)
**Loyihadagi Manzil:**
- Sahifa: `modules/auth/lib/src/presentation/login/login_page.dart`
- Mixin: `modules/auth/lib/src/presentation/login/mixin/login_mixin.dart`

**Mantiq:**
- Matn kontrollerlari va form kaliti mixinda saqlanadi (`_emailController`, `_formKey`).
- Parolni yashirish/ko'rsatish — sof lokal holat (`setState(() => _isPasswordObscured = !_isPasswordObscured)`).
- Validatsiya xatolarini tekshirish: `if (!_formKey.currentState!.validate()) return;`.
- Muvaffaqiyatli kirishda `context.goNamed(Routes.mainHome)` bilan asosiy ekranga o'tadi.
- Barcha controllerlar `dispose()` da tozalanadi.

```dart
part of '../login_page.dart';

mixin LoginMixin on State<LoginPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _rememberMe = false;
  String? _errorMessage;

  LoginBloc get _bloc => context.read<LoginBloc>();

  void _togglePasswordVisibility() {
    setState(() => _isPasswordObscured = !_isPasswordObscured);
  }

  void _handleStates(BuildContext context, LoginState state) {
    if (state is LoginFailureState) {
      _errorMessage = state.message; // BlocConsumer builder o'zi qayta chiziladi
    } else if (state is LoginSuccessState) {
      if (!context.mounted) return;
      showSuccessMessage(context, message: '${context.l10n.loginSuccessMessage}: ${state.user.email}');
      context.goNamed(Routes.mainHome);
    }
  }

  void _loginPressed() {
    final currentForm = _formKey.currentState;
    if (currentForm == null || !currentForm.validate()) return;
    _errorMessage = null;
    _bloc.add(LoginSubmitEvent(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

### Senariy 3: OTP va Kod Kiritish (OTP & Verification)
**Loyihadagi Manzil:**
- Sahifa: `modules/auth/lib/src/presentation/otp_login/otp_login_page.dart`
- Mixin: `modules/auth/lib/src/presentation/otp_login/mixin/otp_login_mixin.dart`

**Mantiq:**
- Tasdiqlash kodi uchun `_codeController`.
- Telegram bot yoki tashqi manzilga havola ochish (`launchUrl` tashqi brauzerda).
- Kod kiritilmaganda lokal xatolik ko'rsatish (`setState(() => _errorMessage = context.l10n.otpCodeRequired)`), chunki bunda BLoC chaqirilmaydi.
- To'g'ri kod bo'lganda `OtpLoginSubmitEvent` orqali BLoC ga uzatish.

```dart
part of '../otp_login_page.dart';

mixin OtpLoginMixin on State<OtpLoginPage> {
  late final TextEditingController _codeController = TextEditingController();
  String? _errorMessage;

  OtpLoginBloc get _bloc => context.read<OtpLoginBloc>();

  void submitOtp() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = context.l10n.otpCodeRequired);
      return;
    }
    _errorMessage = null;
    _bloc.add(OtpLoginSubmitEvent(code: code));
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
```

---

### Senariy 4: Mavjud Ma'lumotni Tahrirlash va Natijani Qaytarish (Edit & Return)
**Loyihadagi Manzil:**
- Sahifa: `modules/profile/lib/src/presentation/edit_profile/edit_profile_page.dart`
- Mixin: `modules/profile/lib/src/presentation/edit_profile/mixin/edit_profile_mixin.dart`

**Mantiq:**
- `widget.args` dan kelgan boshlang'ich ma'lumotlar bilan controllerlar to'ldiriladi (`TextEditingController(text: widget.args.user.username)`).
- Saqlash tugmasi bosilganda form validatsiyasi tekshiriladi va `UpdateProfilePressedEvent` yuboriladi.
- Natija muvaffaqiyatli bo'lsa: `context.pop(true)` bilan avvalgi ekranga signal qaytariladi va avvalgi ekran ro'yxatni yangilaydi.

```dart
part of '../edit_profile_page.dart';

mixin EditProfileMixin on State<EditProfilePage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController = TextEditingController(text: widget.args.user.username ?? '');
  late final TextEditingController _firstNameController = TextEditingController(text: widget.args.user.firstName);
  late final TextEditingController _lastNameController = TextEditingController(text: widget.args.user.lastName);

  void _handleStates(BuildContext context, ProfileState state) {
    if (!context.mounted) return;
    if (state is ProfileUpdatedState) {
      showSuccessMessage(context, message: context.l10n.profileUpdatedSuccess);
      context.pop(true); // O'zgarish bo'lganini avvalgi sahifaga bildiradi
    } else if (state is ProfileFailureState) {
      showErrorMessage(context, message: state.message);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() != true) return;
    bloc.add(
      UpdateProfilePressedEvent(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      ),
    );
  }

  ProfileBloc get bloc => context.read<ProfileBloc>();
}
```

---

### Senariy 5: Moliya va Karta Kiritish (Input Formatting & Detection)
**Loyihadagi Manzil:**
- Sahifa: `modules/payments/lib/src/presentation/add_card/add_card_page.dart`
- Mixin: `modules/payments/lib/src/presentation/add_card/mixin/add_card_mixin.dart`

**Mantiq:**
- Karta raqamidan bo'shliqlarni olib tashlash, Visa/Mastercard kabi to'lov tizimini aniqlash.
- Karta oxirgi 4 ta raqamini ajratib olish va eventga uzatish.
- Saqlangach `context.pop(true)` bilan ro'yxatga qaytish.

```dart
part of '../add_card_page.dart';

mixin AddCardMixin on State<AddCardPage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController = TextEditingController();
  late final TextEditingController _expiryController = TextEditingController();

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    final number = _numberController.text.replaceAll(' ', '').trim();
    final String cardBrand = number.startsWith('4')
        ? 'Visa'
        : number.startsWith('5')
        ? 'Mastercard'
        : 'Unknown';
    final String cardLast4 = number.length >= 4 ? number.substring(number.length - 4) : number;

    context.read<PaymentMethodsBloc>().add(
      PaymentMethodAddEvent(
        cardNumber: number,
        cardLast4: cardLast4,
        cardBrand: cardBrand,
        expiryDate: _expiryController.text.trim(),
        isDefault: false,
      ),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    super.dispose();
  }
}
```

---

### Senariy 6: Dashboard va Ko'p Bo'limli Ekran (Dashboard & Refresh)
**Loyihadagi Manzil:**
- Sahifa: `modules/home/lib/src/presentation/main/home_page.dart`
- Mixin: `modules/home/lib/src/presentation/main/mixin/home_mixin.dart`

**Mantiq:**
- Ekranda bir nechta mustaqil qismlar (kategoriyalar, bizneslar, faol bandliklar) mavjud.
- BLoC butun ekran ma'lumotlarini bitta muvaffaqiyatli holatda (`HomeSuccessState`) taqdim etadi.
- Mixin faqat umumiy xatoliklarni tinglaydi (`_stateListener`) va ekranni qayta yuklash (`_reloadHome`) metodini beradi.

```dart
part of '../home_page.dart';

mixin HomeMixin on State<HomePage> {
  void _stateListener(BuildContext context, HomeState state) {
    if (state is HomeFailureState) {
      showErrorMessage(context, message: state.message);
    }
  }

  void _reloadHome() {
    context.read<HomeBloc>().add(const HomeRefreshEvent());
  }
}
```

---

### Senariy 7: Ilova Bootstrap va Splash (Lifecycle Routing)
**Loyihadagi Manzil:**
- Sahifa: `modules/initial/lib/src/presentation/splash/splash_page.dart`
- Mixin: `modules/initial/lib/src/presentation/splash/mixin/splash_mixin.dart`

**Mantiq:**
- BLoC talab qilinmaydi. Mixin `initState()` da to'g'ridan-to'g'ri `_checkLoginStatus()` ni ishga tushiradi.
- `LocalSource` dan foydalanuvchi tizimga kirgan yoki kirmaganini tekshiradi.
- `context.pushReplacementNamed(isLoggedIn ? Routes.mainHome : Routes.welcome)` orqali navigatsiya stekini almashtiradi.

```dart
part of '../splash_page.dart';

mixin SplashMixin on State<SplashPage> {
  LocalSource get _localSource => AppInjector.instance.get<LocalSource>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus().ignore();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = _localSource.hasProfile;
    if (!mounted) return;
    if (isLoggedIn) {
      context.pushReplacementNamed(Routes.mainHome);
    } else {
      context.pushReplacementNamed(Routes.welcome);
    }
  }
}
```

---

### Senariy 8: Asosiy Shell va Tablar Boshqaruvi (Shell & Tabs)
**Loyihadagi Manzil:**
- Sahifa: `modules/main/lib/src/presentation/main/main_page.dart`
- Mixin: `modules/main/lib/src/presentation/main/mixin/main_mixin.dart`

**Mantiq:**
- `go_router` ning `StatefulNavigationShell` ga asoslangan.
- Foydalanuvchi pastki menyudan (BottomNavigationBar) boshqa tabni tanlaganda:
  ```dart
  void _onTabTapped(int index) {
    if (index == widget.navigationShell.currentIndex) return;
    widget.navigationShell.goBranch(index);
  }
  ```

---

### Senariy 9: Tizim va Statik Sahifalar (Static & Fallback Pages)
**Loyihadagi Manzil:**
- `modules/system/lib/src/presentation/not_found/not_found_page.dart`
- `modules/system/lib/src/presentation/internet_connection/internet_connection_page.dart`

**Mantiq:**
- BLoC yoki murakkab Mixin talab qilinmaydi (`StatelessWidget`).
- Faqat foydalanuvchiga xatolik haqida xabar berish va orqaga qaytish yoki tarmoqni qayta tekshirish tugmasi bo'ladi.

---

## 5. Eng Ko'p Qilinadigan Xatolar (Anti-patterns)

- ❌ Barcha sahifalarga majburiy paginatsiya kodlarini (scroll listener, `_page`) ko'chirib qo'yish (senariyga qarab mos etalonni tanlang).
- ❌ BLoC ichida controller, ro'yxat yoki form validatsiyasini saqlash (ma'lumot egasi — Mixin).
- ❌ `build()` ichida controller yoki listener yaratish (har buildda xotira sizib chiqadi).
- ❌ `BlocBuilder` bor joyda `_handleStates` ichida ortiqcha `setState` chaqirish.
- ❌ Controllerlarni `dispose()` da xotiradan tozalamaslik.
- ❌ `context.pop(true)` o'rniga `Navigator.of(context).pop()` ishlatish.

---

## 6. Tekshiruv Ro'yxati (Checklist)

- [ ] Tanlangan senariy turi aniq belgilangan va mos etalon ko'chirib olindi.
- [ ] Mixin `part of '../<feature>_page.dart'` orqali ulangan.
- [ ] Barcha o'zgaruvchi ma'lumotlar va controllerlar mixinda yashaydi, BLoC stateless.
- [ ] Agar paginatsiya bo'lsa: set-union (`{..._items, ...state.items}.toList()`) va `< defaultPageLimit` tekshiruvi bor.
- [ ] Agar forma bo'lsa: `_formKey.currentState.validate()` tekshiruvi bor.
- [ ] Barcha controllerlar (`TextEditingController`, `ScrollController`) `dispose()` da yopilgan.
- [ ] `setState` faqat lokal UI holat (toggle, checkbox) yoki BLoC'siz xatoliklar uchun ishlatilgan.

