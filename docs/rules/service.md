# service.md — Servis qatlami (websocket, audio, uzoq yashovchi holat)

> Oddiy topshiriq uchun shu blok yetarli — pastini faqat yangi transport qo'shayotganda o'qi.
>
> ### Qattiq qoidalar (TL;DR)
> - Servis — usecase emas: `Either` qaytarmaydi, `Failure` yasamaydi, `context` va widget ko'rmaydi.
> - Tashqi I/O (websocket, audio, push notifications) → `abstract interface class XService` + `final class XServiceImpl`,
>   DI da ro'yxatdan o'tadi. Sof logika (parser, tracker) → oddiy `class`, DI yo'q.
> - Ochilgan har narsa yopiladi: `disconnect()` / `dispose()` bor va **mixin**ning `dispose()` idan chaqiriladi.
> - Tashqi klientni konstruktorga inject qil (`typedef XFactory`), aks holda test yozib bo'lmaydi.
> - Servis xabarni **ko'rsatmaydi** (snackbar/dialog — mixin ishi).

## 1. Qaysi papka

| Nima | Joy |
|---|---|
| tashqi transport / SDK adapteri (ws, audio, realtime) | `lib/src/data/service/` |
| modul ichidagi uzoq yashovchi servis yoki sof logika | `lib/src/service/` |

`arch-guard` bu papkalarda fayl/klass suffiksini tekshirmaydi, demak nomni o'zing to'g'ri qo'yasan:
fayl `snake_case`, klass `PascalCase`, I/O servis nomi `...Service` / `...ServiceImpl` bilan tugaydi.

## 2. I/O servis shakli

```dart
abstract interface class SocketService {
  const new();
  Future<void> connect({required void Function(Object? data) onData});
  Future<void> disconnect();
}

final class SocketServiceImpl implements SocketService {
  const new();

  @override
  Future<void> connect({required void Function(Object? data) onData}) async {}

  @override
  Future<void> disconnect() async {}
}
```

- Bitta implementatsiya bo'lsa interfeys va impl bitta faylda.
- Mutable field bu yerda ruxsat (soket, subscription, timer) — bloc'dagi taqiq servisga tegishli emas.
- Xatolik: `logMessage('...', error: e, stackTrace: s)` + callback/`Stream` orqali xabar ber. `print` — taqiq.

## 3. DI

```dart
..registerLazySingleton<SocketService>(SocketServiceImpl.new)   // app bo'yicha bitta ulanish
..registerFactory<SocketService>(SocketServiceImpl.new)         // har ekranga yangi nusxa
```

## 4. Kim egalik qiladi va kim yopadi

- Ekranga bog'liq servis — **mixin** fieldi (`docs/rules/page-mixin.md`), bloc'da emas.
- Servisdan kelgan ma'lumot event orqali bloc'ga uzatiladi; bloc state emit qiladi; mixin qabul qiladi.
