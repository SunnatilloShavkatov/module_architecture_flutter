---
description: arch-guard buzilishlarini topib tuzatish
allowed-tools: Read, Edit, Bash(bash scripts/arch_guard_scan.sh:*), Grep
---

1. `bash scripts/arch_guard_scan.sh --changed` ishga tushir.
2. Har bir xabar uchun **faqat ko'rsatilgan qatorni** tuzat — faylni to'liq qayta o'qima.
3. Tozalanmaguncha takrorla (maksimum 3 marta), keyin qolganini xabar qil.

Qoida tegishli bo'lmasa — istisno izohi (sabab majburiy):
`// arch-guard: allow <id> — <sabab>` (`AGENTS.md` §5).

`flutter analyze` ishlatma — guard yetarli.

$ARGUMENTS
