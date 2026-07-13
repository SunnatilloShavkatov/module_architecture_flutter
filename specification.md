# Module Architecture Mobile — Project Specification

## 1. Hujjat maqsadi

Ushbu specification Flutter asosidagi modular monorepo mobil ilovani (Clean Architecture + Bloc + GoRouter + DI) ishlab chiqish, kengaytirish va AI orqali bir xil standartda davom ettirish uchun yagona manba hisoblanadi.

## 2. Loyiha haqida qisqa ma’lumot

- **Platforma:** Flutter (Android/iOS)
- **Arxitektura:** Modular monorepo + Clean Architecture (Presentation / Domain / Data)
- **State management:** Bloc (sealed event/state)
- **Routing:** GoRouter
- **DI:** GetIt (via `merge_dependencies`)
- **Core paketlar:** `core`, `components`, `navigation`, `platform_methods`, `merge_dependencies`
- **Environment:** `dev`, `prod`
- **Firebase:** Core, Messaging, AppCheck (main init jarayonida)

## 3. Scope (MVP va keyingi bosqich)

### 3.1 MVP scope (hozirgi asosiy oqim)

1. Splash orqali login holatini tekshirish.
2. Welcome sahifasi (email/telegram login kirishlari).
3. Auth:
   - Email + password login
   - Telegram OTP login
4. Main shell (bottom tab navigation).
5. Home dashboard:
   - Kategoriyalar
   - Aktiv bizneslar
   - Upcoming appointmentlar
6. Profile:
   - Profil ko‘rish
   - Profilni yangilash
   - Sozlamalar (theme mode)

### 3.2 Kengaytirilgan scope

1. Notifications moduli (list + filter).
2. Payments moduli (card list/add/delete).
3. System moduli (no-internet, not-found).

## 4. Modul ownership va javobgarlik

- `modules/initial` — splash/welcome/startup oqimi.
- `modules/auth` — autentifikatsiya va session boshlanishi.
- `modules/main` — app shell va tab-based navigation.
- `modules/home` — dashboard kontent.
- `modules/profile` — user profile + settings.
- `modules/notifications` — notificationlar.
- `modules/payments` — payment methodlar.
- `modules/system` — system fallback sahifalari.
- `packages/core` — infra: network, error, local storage, usecase abstractions.
- `packages/components` — design system componentlari.
- `packages/navigation` — route nomlari va observerlar.
- `packages/merge_dependencies` — modul registratsiyasi va global router agregatsiyasi.

## 5. Funksional talablar (FR)

### FR-01 Startup

- App ishga tushganda environment init bo‘lishi shart.
- Firebase notification xizmati init qilinadi.
- Module DI registration bir marta bajariladi.

### FR-02 Login status check

- Splash `LocalSource.hasProfile` bo‘yicha:
  - `true` bo‘lsa `Routes.mainHome`
  - `false` bo‘lsa `Routes.welcome`

### FR-03 Auth (email login)

- User email + password yuboradi.
- API muvaffaqiyatli javob qaytarsa:
  - token saqlanadi
  - user basic profile cache qilinadi
  - main home ga o‘tiladi
- Xatoda localized error ko‘rsatiladi.

### FR-04 Auth (OTP login)

- Telegram bot URL ochish imkoniyati bo‘lishi kerak.
- OTP code bilan login qilinadi.
- Success holatda main home ga o‘tiladi.

### FR-05 Home dashboard

- 3 manba birga yuklanadi:
  - categories
  - businesses
  - appointments
- Appointmentlar vaqt bo‘yicha saralanadi, upcoming ko‘rsatiladi.
- Failure bo‘lsa qayta urinish (reload) beriladi.

### FR-06 Profile

- Profil ma’lumotini olish (`get me`) va local cache fallback.
- Profil yangilash endpointi.
- Update success bo‘lsa UI darhol yangilanadi.

### FR-07 Settings

- Theme mode tanlash (system/light/dark) va LocalSource ga saqlash.

### FR-08 Notifications

- Notification list olish.
- Filterlar: All / Unread / Promos.
- Remote xatoda local mock fallback ishlashi kerak.

### FR-09 Payments

- Payment methods list.
- Yangi karta qo‘shish.
- Kartani o‘chirish.
- Action success/failure userga snackbar bilan ko‘rsatiladi.

### FR-10 System fallback

- No-internet route mavjud bo‘lishi kerak.
- Router noaniq route holatini NotFound orqali boshqaradi.

## 6. API contract (modulga izolyatsiyalangan endpointlar)

- **Auth**
  - `POST /api/auth/login`
  - `POST /api/auth/otp/login`
- **Home**
  - `GET /api/categories`
  - `GET /api/businesses/active`
  - `GET /api/appointments/client`
- **Profile**
  - `GET /api/auth/me`
  - `PATCH/PUT /api/auth/profile` (impl bo‘yicha)
- **Notifications**
  - `GET /api/notifications/client`
- **Payments**
  - `GET /api/payment-methods/client`
  - `POST /api/payment-methods/client`
  - `DELETE /api/payment-methods/{id}/client`

## 7. Ma’lumotlar modeli (asosiy entitylar)

- **UserEntity**: id, email, firstName, lastName, role, phone, token, username, specialization
- **HomeCategoryEntity**: id, name, slug, icon
- **HomeBusinessEntity**: id, name, rating, reviewCount, imageUrl, distance, waitTime, isOpen, description, workingHours, phoneNumber, address
- **HomeAppointmentEntity**: id, userId, businessId, staffId, services[], startTime, endTime, status, totalPrice, business?, staff?
- **ProfileUserEntity**: id, email, firstName, lastName, role, phone, username, specialization
- **NotificationEntity**: id, title, message, timestamp, isRead, type, timeAgo?
- **PaymentMethodEntity**: id, cardLast4, cardBrand, expiryDate, isDefault

## 8. Arxitektura va kodlash standarti (AI uchun majburiy)

1. Har feature **owner module** ichida yoziladi.
2. Har modulda qatlamlar:
   - `data/`
   - `domain/`
   - `presentation/`
   - `di/`
   - `router/`
3. Dependency qoidasi qat’iy: `Presentation -> Domain <- Data`.
4. Bloc faqat usecase chaqiradi, repository’ni bevosita chaqirmaydi.
5. Model entity’dan extend qiladi; mapping `fromMap/toMap`.
6. Har modul o‘z `ApiPaths` klassiga ega bo‘lishi kerak (global endpoint yo‘q).
7. DI tartibi: data source -> repository -> usecase -> bloc.
8. Router modul ichida; global agregatsiya faqat `merge_dependencies`.
9. `repo/repository` naming uslubi modul ichida aralashtirilmaydi.
10. Error handling: exception -> `Failure` (`Either` pattern).

## 9. Nofunksional talablar (NFR)

- **NFR-01 Maintainability:** modul izolyatsiyasi, low coupling.
- **NFR-02 Scalability:** yangi modul qo‘shish `container + injection + router + merge_dependencies`.
- **NFR-03 Reliability:** network xatolar `ServerException/Failure` orqali standard ishlov.
- **NFR-04 Security:** token secure storage’da, Hive encrypted box.
- **NFR-05 Performance:** lazy singleton dependencylar, bloc observerlar (debug/profile).
- **NFR-06 Localization:** localized messages va locale header qo‘llab-quvvatlanadi.
- **NFR-07 Code quality:** lint/fix/format/analyze pipeline.

## 10. Testing talablari

- Har modul uchun kamida:
  - usecase test
  - repository test
  - bloc test
  - critical model mapping test
- Router/DI testlari (`auth` modulda mavjud pattern kabi) qo‘llanadi.
- Regression testlar login, profile update, home load, payments actions, notifications filter oqimlarini qamrashi kerak.

## 11. Build/Release talablari

- Entry points:
  - `lib/main_dev.dart`
  - `lib/main_prod.dart`
- Flavor run/build komandalar hujjatdagi ko‘rsatmaga mos.
- `.env.dev.json` va `.env.prod.json` orqali environment qiymatlari beriladi.

## 12. Definition of Done (DoD)

Task tugallangan hisoblanadi agar:

1. Owner module aniq tanlangan bo‘lsa.
2. Qatlamlar to‘liq (domain -> data -> presentation -> di -> router) ulanib ishlasa.
3. API contract modul ichida izolyatsiyalangan bo‘lsa.
4. Lint/analyze o‘tsa.
5. Tegishli testlar yozilgan va o‘tsa.
6. MergeDependencies orqali modul real app routing/DI ga qo‘shilgan bo‘lsa.

## 13. Hozirgi loyiha bo‘yicha muhim holat (implementation note)

- `payments` moduli kodda mavjud, lekin `merge_dependencies` registratsiyasida hozircha qo‘shilmagan (integratsiya talab qilinadi).
- `notifications` router hozircha bo‘sh (route publish qilish talab qilinadi).
- `home` router bo‘sh, home sahifa `PageFactory` orqali `main` shell ichida ochilmoqda (qabul qilingan pattern).
