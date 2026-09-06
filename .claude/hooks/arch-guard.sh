#!/usr/bin/env bash
# arch-guard.sh — .claude/rules/flutter-architecture.md dagi qoidalarni majburlaydi.
#
# RULES bloki §2 jadvalidan mexanik hosil qilingan. Faqat ≥90% ustunlikka ega qatorlar.
# Jadval o'zgarsa — bu blok ham o'zgarishi shart (ikkalasi belgi-ba-belgi mos turishi kerak).
#
# Kirish : stdin da {"tool_input":{"file_path":"/abs/path.dart"}}
# Chiqish: 0 = toza, 2 = qoida buzilgan (stderr da sabab)

set -uo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# RULES: "papka_qismi|ruxsat_etilgan_suffikslar|klass_suffiksi"
# Tartib muhim — birinchi mos kelgan qator qo'llanadi.
# Faqat modules/*/lib/src/ ga tegishli (packages/ o'z sxemasiga ega, o'lchov konvensiya topmadi).
# ─────────────────────────────────────────────────────────────────────────────
RULES=(
  "/lib/src/presentation/*/bloc/|_bloc.dart,_event.dart,_state.dart|Bloc,Event,State"
  "/lib/src/presentation/*/mixin/|_mixin.dart|Mixin"
  "/lib/src/presentation/*/args/|_args.dart|Args"
  "/lib/src/presentation/|_page.dart,_sheet.dart|Page,Sheet"
  "/lib/src/domain/entities/|_entity.dart|Entity"
  "/lib/src/domain/repository/|_repository.dart,_repo.dart|Repository,Repo"
  "/lib/src/domain/repos/|_repository.dart,_repo.dart|Repository,Repo"
  "/lib/src/data/models/|_model.dart|Model"
  "/lib/src/data/datasource/|_data_source.dart,_data_source_impl.dart,_api_paths.dart|DataSource,DataSourceImpl,ApiPaths"
  "/lib/src/data/repository/|_impl.dart|Impl"
  "/lib/src/data/repo/|_impl.dart|Impl"
  "/lib/src/router/|_router.dart|Router"
  "/lib/src/di/|_injection.dart|Injection"
)

MODULES="auth|home|initial|main|notifications|payments|profile|system"
PACKAGES="core|components|navigation|platform_methods|merge_dependencies"

fail() { printf 'arch-guard: %s\n  %s\n' "$1" "$REL" >&2; exit 2; }

# ── kirishni o'qish ──────────────────────────────────────────────────────────
RAW=$(cat)
FILE=$(printf '%s' "$RAW" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[ -n "$FILE" ] || exit 0
case "$FILE" in *.dart) ;; *) exit 0 ;; esac
[ -f "$FILE" ] || exit 0

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
REL=${FILE#"$ROOT"/}
BASE=${REL##*/}

# generatsiya qilingan / test / vendor fayllar tekshirilmaydi
case "$REL" in
  */test/*|*/integration_test/*|*.g.dart|*.freezed.dart|*/l10n/app_localizations*|*/build/*|*/.dart_tool/*|*/example/*)
    exit 0 ;;
esac

# To'liq izoh qatorlari olib tashlanadi — izohga olingan kod qoida buzmaydi.
SRC=$(sed -e 's|^[[:space:]]*//.*$||' -e 's|^[[:space:]]*\*.*$||' "$FILE")

# ─────────────────────────────────────────────────────────────────────────────
# 1. Import qoidalari (§3) — o'lchovda 0 buzilish
# ─────────────────────────────────────────────────────────────────────────────
grep -q "^import 'package:flutter/material.dart'" <<<"$SRC" &&
  fail "package:flutter/material.dart taqiqlanadi -> package:material_ui/material_ui.dart"
grep -q "^import 'package:flutter/cupertino.dart'" <<<"$SRC" &&
  fail "package:flutter/cupertino.dart taqiqlanadi -> package:cupertino_ui/cupertino_ui.dart"
grep -qE "^import '\.{1,2}/" <<<"$SRC" &&
  fail "nisbiy import taqiqlanadi -> package: yo'li ishlatilsin"

# o'z paketidan tashqari hech qanday src/ ga kirish yo'q
OWNER=$(sed -nE 's|^(modules\|packages)/([a-z_]+)/.*|\2|p' <<<"$REL")
while read -r dep; do
  [ -z "$dep" ] && continue
  [ "$dep" = "$OWNER" ] && continue
  fail "package:$dep/src/... deep import taqiqlanadi -> package:$dep/$dep.dart barreli"
done < <(grep -oE "^import 'package:($MODULES|$PACKAGES)/src/" <<<"$SRC" | sed -E "s|^import 'package:||;s|/src/$||" | sort -u)

# modul boshqa modulni import qilmaydi
case "$REL" in
  modules/*)
    while read -r dep; do
      [ -z "$dep" ] && continue
      [ "$dep" = "$OWNER" ] && continue
      fail "modullararo import taqiqlanadi (package:$dep/) -> PageFactory / WidgetFactory / ModuleInteractor"
    done < <(grep -oE "^import 'package:($MODULES)/" <<<"$SRC" | sed -E "s|^import 'package:||;s|/$||" | sort -u)
    ;;
esac

# ─────────────────────────────────────────────────────────────────────────────
# 2. Taqiqlangan API (§5, §6) — o'lchovda 0 buzilish
# ─────────────────────────────────────────────────────────────────────────────
grep -qE '(^|[^A-Za-z_])Navigator\.(push|pop|of)\(' <<<"$SRC" &&
  fail "Navigator 1.0 taqiqlanadi -> context.pushNamed / goNamed / pop"
grep -q 'MediaQuery.of(' <<<"$SRC" &&
  fail "MediaQuery.of(context) taqiqlanadi -> context.width / context.height / context.padding"
grep -qE '(^|[^A-Za-z_.])print\(' <<<"$SRC" &&
  fail "print() taqiqlanadi -> loyiha loggeri"

# ─────────────────────────────────────────────────────────────────────────────
# 3. Qatlamga xos taqiqlar
# ─────────────────────────────────────────────────────────────────────────────
case "$REL" in
  modules/*/lib/src/domain/*)
    grep -qE '\b(fromMap|toMap)\b' <<<"$SRC" &&
      fail "domain/ da fromMap/toMap taqiqlanadi -> data/models/ ichida"
    grep -qE "^import 'package:(material_ui|cupertino_ui|flutter)/" <<<"$SRC" &&
      fail "domain/ UI'dan xoli bo'lishi shart — widget importi taqiqlanadi"
    ;;
esac

case "$REL" in
  modules/*/lib/src/presentation/*)
    grep -qE '(^|[^A-Za-z_.])Colors\.' <<<"$SRC" &&
      fail "Colors.* hardcode taqiqlanadi -> context.color.* / context.colorScheme.*"
    grep -q 'Color(0x' <<<"$SRC" &&
      fail "Color(0x...) hardcode taqiqlanadi -> context.color.*"
    ;;
esac

case "$BASE" in
  *_router.dart)
    grep -q 'pageBuilder:' <<<"$SRC" &&
      fail "modul router'ida pageBuilder: taqiqlanadi -> CupertinoRoute / MaterialSheetRoute"
    ;;
  *_bloc.dart)
    grep -qE 'Future<void> _on[A-Z]' <<<"$SRC" &&
      fail "handler nomi _on<Xxx> taqiqlanadi -> _<verb><Target>Handler"
    while IFS= read -r line; do
      grep -q 'transformer:' <<<"$line" ||
        fail "on<Event>() da transformer: majburiy (throttle=yozuv, droppable=o'qish): ${line#"${line%%[![:space:]]*}"}"
    done < <(grep -E '^\s*on<[A-Za-z0-9_]+>\(' <<<"$SRC")
    ;;
  *_mixin.dart)
    grep -qE "^part of '" <<<"$(head -1 "$FILE")" ||
      fail "mixin fayli \"part of '../<feature>_page.dart';\" bilan boshlanishi shart"
    ;;
esac

# ─────────────────────────────────────────────────────────────────────────────
# 4. RULES: fayl suffiksi + klass suffiksi (§2)
# ─────────────────────────────────────────────────────────────────────────────
case "$REL" in modules/*) ;; *) exit 0 ;; esac

for rule in "${RULES[@]}"; do
  frag=${rule%%|*}; rest=${rule#*|}
  files=${rest%%|*}; classes=${rest#*|}

  case "/$REL" in *$frag*) ;; *) continue ;; esac

  ok=0
  IFS=',' read -ra want <<<"$files"
  for s in "${want[@]}"; do case "$BASE" in *"$s") ok=1 ;; esac; done
  [ "$ok" = 1 ] || fail "fayl nomi '$frag' uchun ruxsat etilgan suffikslardan biri bilan tugashi shart: $files"

  DECL=$(grep -oE '^(abstract interface class|abstract base class|abstract class|final class|sealed class|base class|interface class|class|mixin|enum) [A-Za-z][A-Za-z0-9_]*' <<<"$SRC" \
         | head -1 | awk '{print $NF}')
  [ -n "$DECL" ] || exit 0

  ok=0
  IFS=',' read -ra want <<<"$classes"
  for s in "${want[@]}"; do case "$DECL" in *"$s") ok=1 ;; esac; done
  [ "$ok" = 1 ] || fail "birinchi ommaviy klass '$DECL' — suffikslardan biri bo'lishi shart: $classes"

  break
done

exit 0
