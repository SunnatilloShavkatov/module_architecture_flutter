#!/usr/bin/env bash
# arch-guard.sh — enforces .claude/rules/flutter-architecture.md
#
# Reads a hook payload on stdin: {"tool_input":{"file_path":"/abs/path/x.dart"}}
# Exit 0 = allowed. Exit 2 = violation (message on stderr).
#
# Scope: modules/*/lib/**/*.dart only. packages/**, root lib/** and test/** are
# out of scope — they follow different conventions (see rules §9, §10).
#
# The RULES block below is generated mechanically from the table in
# .claude/rules/flutter-architecture.md §2. Keep both in sync.
#
# All content checks run against a comment-stripped copy of the file, so a rule
# never fires on commented-out code.

set -uo pipefail

# "path_marker|allowed_file_suffixes|matching_class_suffixes"
# Suffix lists are positional: the Nth file suffix requires the Nth class suffix.
# Markers starting with @ are positional (not path substrings).
RULES=(
  "@src_root|_container,_factory|Container,Factory"
  "@presentation_root|_page,_sheet,_dialog,_widget|Page,Sheet,Dialog,Widget"
  "/src/data/models/|_model|Model"
  "/src/data/datasource/|_source,_impl,_api_paths,_datasource|Source,Impl,ApiPaths,DataSource"
  "/src/data/repository/|_impl|RepositoryImpl"
  "/src/domain/repository/|_repository|Repository"
  "/src/domain/interactor/|_interactor|Interactor"
  "/src/di/|_injection|Injection"
  "/src/router/|_router|Router"
  "/bloc/|_bloc,_event,_state|Bloc,Event,State"
  "/mixin/|_mixin|Mixin"
  "/args/|_args|Args"
)

payload=$(cat)
file_path=$(printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

[ -z "$file_path" ] && exit 0
[ -f "$file_path" ] || exit 0

case "$file_path" in
  *.dart) ;;
  *) exit 0 ;;
esac

rel=${file_path#"$PWD"/}

# --- scope -------------------------------------------------------------------
case "$rel" in
  modules/*/lib/*) ;;
  *) exit 0 ;;
esac
case "$rel" in
  */test/*|*_test.dart|*/test_helpers/*) exit 0 ;;
esac

base=$(basename "$rel" .dart)
fail() { echo "arch-guard: $rel" >&2; echo "  $1" >&2; exit 2; }

# --- opt-out --------------------------------------------------------------
if head -3 "$file_path" | grep -qE '^// arch-guard: ignore[[:space:]]+[^[:space:]]'; then
  exit 0
fi

# Comment-stripped copy — every content check reads this, never the raw file.
code=$(mktemp -t arch-guard)
trap 'rm -f "$code"' EXIT
sed -E 's@^[[:space:]]*//.*$@@' "$file_path" > "$code"

has_decl() { # $1 = class-name suffix; case-insensitive
  grep -qiE '^[a-z ]*(class|mixin|enum|typedef|extension) [A-Za-z0-9_]*'"$1"'\b' "$code"
}

# --- 1. structure: file suffix + class suffix (rules §2) ----------------------
matched=""
for rule in "${RULES[@]}"; do
  marker=${rule%%|*}
  rest=${rule#*|}
  suffixes=${rest%%|*}
  classes=${rest##*|}

  case "$marker" in
    @src_root)
      # modules/<m>/lib/src/<file>.dart — nothing between src/ and the file
      [[ "$rel" =~ ^modules/[^/]+/lib/src/[^/]+\.dart$ ]] || continue
      ;;
    @presentation_root)
      # modules/<m>/lib/src/presentation/<feature>/<file>.dart
      [[ "$rel" =~ ^modules/[^/]+/lib/src/presentation/[^/]+/[^/]+\.dart$ ]] || continue
      # presentation/widgets/ is the module-wide shared widget bucket, not a
      # feature — same exemption as presentation/<feature>/widgets/ (rules §2).
      [[ "$rel" =~ ^modules/[^/]+/lib/src/presentation/widgets/ ]] && continue
      ;;
    *)
      case "$rel" in *"$marker"*) ;; *) continue ;; esac
      ;;
  esac

  matched="$marker"
  IFS=',' read -r -a sfx <<< "$suffixes"
  IFS=',' read -r -a cls <<< "$classes"

  hit=-1
  for i in "${!sfx[@]}"; do
    case "$base" in *"${sfx[$i]}") hit=$i; break ;; esac
  done

  if [ "$hit" -lt 0 ]; then
    fail "file name must end with one of: ${suffixes//,/.dart, }.dart"
  fi
  if ! has_decl "${cls[$hit]}"; then
    fail "'${sfx[$hit]}.dart' must declare a class/mixin ending in '${cls[$hit]}'"
  fi
  break
done

# --- 2. bloc specifics (rules §4) --------------------------------------------
case "$rel" in */bloc/*) bloc_scope=1 ;; *) bloc_scope=0 ;; esac
[ "$bloc_scope" = 1 ] && case "$base" in
  *_bloc)
    grep -qE "^part '" "$code" \
      || fail "_bloc.dart must 'part' its _event.dart and _state.dart"
    if grep -qE '\bon<[A-Za-z0-9_]+>\(' "$code" \
       && [ "$(grep -cE '\bon<[A-Za-z0-9_]+>\(' "$code")" -ne "$(grep -c 'transformer:' "$code")" ]; then
      fail "every on<Event>() needs an explicit transformer:"
    fi
    while IFS= read -r h; do
      case "$h" in *Handler) ;; *) fail "bloc handler '$h' must be named _<verb><target>Handler" ;; esac
    done < <(grep -ohE '\bon<[A-Za-z0-9_]+>\([[:space:]]*_[A-Za-z0-9_]+' "$code" | sed -E 's/.*\([[:space:]]*//')
    ;;
  *_event|*_state)
    grep -qE '^part of ' "$code" || fail "$base.dart must be 'part of' its bloc"
    grep -qE '^sealed class ' "$code" || fail "$base.dart root type must be a 'sealed class'"
    ;;
esac

# --- 3. mixin shape (rules §2) -----------------------------------------------
case "$base" in
  *_mixin)
    grep -qE '^mixin [A-Za-z0-9_]+Mixin on State<' "$code" \
      || fail "must be declared as 'mixin <Name>Mixin on State<...>'"
    ;;
esac

# --- 4. imports (rules §3) ---------------------------------------------------
grep -qE "^import '(\.\./|\./)" "$code" \
  && fail "relative imports are forbidden in lib/ — use package: imports"

grep -qE "^import 'package:(core|components|navigation|platform_methods|base_dependencies|wiredash)/src/" "$code" \
  && fail "never import another package's src/ — use its barrel (package:core/core.dart)"

self=$(printf '%s' "$rel" | cut -d/ -f2)
if [ -d modules ]; then
  others=$(ls modules | grep -v "^${self}$" | tr '\n' '|' | sed 's/|$//')
  [ -n "$others" ] && grep -qE "^import 'package:($others)/" "$code" \
    && fail "modules/* must never import another module — use ModuleInteractor / PageFactory / WidgetFactory"
fi

grep -qE "^import 'package:flutter/material\.dart'" "$code" \
  && fail "use package:material_ui/material_ui.dart instead of package:flutter/material.dart"

# --- 5. banned APIs (rules §5, §6, §7) ---------------------------------------
ban() { grep -qE "$1" "$code" && fail "$2"; return 0; }

ban '(^|[^A-Za-z0-9_.])MediaQuery\.of\('        "MediaQuery.of() -> context.width / context.height / context.padding"
ban '(^|[^A-Za-z0-9_.])Theme\.of\('             "Theme.of() -> context.color / context.textStyle"
ban '(^|[^A-Za-z0-9_.])EdgeInsets\.all\('       "EdgeInsets.all() -> Dimensions.kPaddingAll*"
ban '(^|[^a-zA-Z_.])(print|debugPrint)\('       "print()/debugPrint() -> logMessage('...', error: e, stackTrace: s)"
ban '(^|[^A-Za-z0-9_.])(Navigator\.(push|pop)|MaterialPageRoute)' "Navigator.push/pop, MaterialPageRoute -> context.pushNamed / context.pop"
ban '(^|[^A-Za-z0-9_.])(fromJson|toJson)\b'     "fromJson/toJson -> fromMap/toMap"
ban '(^|[^A-Za-z0-9_.])(showDialog|showModalBottomSheet)(<[^>]*>)?\(' "showDialog()/showModalBottomSheet() -> MaterialDialogRoute<T> / MaterialSheetRoute<T> registered in the router"

# Hardcoded user-facing copy: Text('literal'). Literals with no letter ('404', '1.0.0') and
# interpolated strings are left alone; the latter are an l10n-placeholder problem, not this rule.
q="'"
ban "(^|[^A-Za-z0-9_])Text\([[:space:]]*(const[[:space:]]+)?$q[^$q\$]*([A-Za-z]|[^ -~])[^$q\$]*$q" \
    "hardcoded Text('...') -> Text(context.l10n.<key>)"

grep -oE 'SizedBox\((height|width): *[0-9][^)]*\)?' "$code" | grep -qv 'child:' \
  && fail "SizedBox(height:/width:) -> spacing: or Dimensions.kGap*"

# --- 6. const new(...) constructors (rules §2) --------------------------------
awk '
  match($0, /^[[:space:]]*(abstract |final |sealed |base |interface |mixin )*class [A-Za-z0-9_]+/) {
    line = $0
    sub(/.*class /, "", line)
    sub(/[^A-Za-z0-9_].*/, "", line)
    cls = line
    next
  }
  cls != "" && $0 ~ ("^[[:space:]]+const " cls "[[:space:]]*[(.]") { found = 1; exit }
  END { exit found ? 1 : 0 }
' "$code" || fail "declare constructors as 'const new(...)', not 'const <ClassName>(...)'"

exit 0
