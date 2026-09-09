# /bloc

Faqat shu ikki manbani o'qi, boshqasini emas:
1. `modules/notifications/lib/src/presentation/notifications/bloc/notifications_bloc.dart` — etalon
   (ko'p-operatsiyali sealed state kerak bo'lsa: yonidagi `notifications_state.dart`)
2. `docs/rules/bloc.md` — TL;DR bloki (davomini faqat yangi pattern kerak bo'lsa)

Yoz: `modules/<module>/lib/src/presentation/<feature>/bloc/<feature>_bloc.dart`
+ `part` qilingan `_event.dart` va `_state.dart`.

Talab:
- event `<Verb><Noun>Event`, state `<Noun><Holat>State`, handler `_<verb><target>Handler`
- har `on<Event>()` da aniq `transformer:` (`droppable()`, `throttle()`, `debounce()`)
- dependency'lar `private final`, bloc ichida mutable field yo'q (ma'lumot mixin'da)
- event/state ildizi `sealed class` + `part of`; bloc `final class`
- konstruktor `const new(...)` (bloc konstruktori `const` emas)

Turn ichida analyze/test ishlatma. Guard xabari kelsa — o'sha qatorni tuzat.

Topshiriq foydalanuvchidan olinadi.

Qoidalar manbasi: `AGENTS.md`. Turn ichida analyze/test/pub get yo'q (§7).
