# AGENTS.md

Two files govern this repo, and they do different jobs:

| File                        | What it is                                                                 | When to open it |
|-----------------------------|----------------------------------------------------------------------------|-----------------|
| **[`CLAUDE.md`](CLAUDE.md)** | The rules and the *why*. Single source of truth; overrides any module's local style. | Every session, before planning |
| **[`docs/template_reference.md`](docs/template_reference.md)** | The *shape* — copy-paste form of every file type, each section pointing back at the rule it implements. | Before writing **each** file |

This file adds only the working procedure and output style. It overrides nothing.

## The loop (follow it in this order — most mistakes come from skipping a step)

1. **Pick the owner module.** State `Owner module:` + `Reason:`. Ambiguous? `docs/architecture/module_selection.md`, cross-checked against `ls modules/`.
2. **Open the docs the task needs.** `CLAUDE.md` §0 maps task → required doc. "I remember this pattern" is not a substitute; the docs carry edge cases the summary drops.
3. **Open `docs/template_reference.md` at the section for the file you're about to write.** Not the whole file — the section. §0 (non-negotiables) applies to everything.
4. **Copy the shape from the template, not from a nearby module.** Modules predate rules; the template doesn't. If an existing module disagrees with `CLAUDE.md`, write the new code correctly and say the old file mismatches — never propagate it, never "fix" it silently as scope creep.
5. **Build in order:** domain (entity → repo interface → usecase) → data (model → api paths → datasource → repo impl) → presentation (bloc → page/mixin → widgets) → DI → router.
6. **Run the gate:** `dart fix --apply && dart format ./ && flutter analyze`. Clean output, or it isn't done.
7. **Self-check against the symptom→fix table** at `docs/template_reference.md` §12, then the Definition of Done in `CLAUDE.md` §17.
8. **Report:** owner module + reason, touched files, anything you deliberately left out.

## The five that get missed most (full detail in the template's §0 and §12)

- `const new()` / `new(...)` / `const new _()` / `factory fromMap(...)` — Dart 3.47 constructor shorthand in declarations. Call sites keep the class name.
- `package:material_ui/material_ui.dart` — `package:flutter/material.dart` does not resolve here.
- `CupertinoRoute` for pages, `MaterialSheetRoute` for sheets. A bare `GoRoute` loses the transition and the iOS swipe-back.
- Handler naming `_<verb><Target>Handler`, and a transformer on every event that calls a usecase (`throttle()` for writes, `droppable()` for reads).
- `setState` only where nothing else will rebuild the field — never duplicating a rebuild a `BlocBuilder`/`BlocConsumer` already does.

Never guess an API name. `Dimensions.*` tokens, `context.color.*`, `context.textStyle.*` and the `components` exports are finite lists — read the file (`packages/components/lib/components.dart`, `.../utils/dimensions.dart`) instead of inventing a plausible name. If something you need genuinely isn't exported from a barrel, add the export line to the barrel rather than importing `package:<pkg>/src/...`.

## Output discipline

- No long theoretical preamble. `Owner module:` + `Reason:`, then the code.
- One file path + one code block per file, no narration between blocks.
- Production-ready only — no `TODO`, no placeholder logic, no dummy data.
- Never invent a base class, JSON-parsing style, bloc pattern, or fourth architecture. They are already defined in `CLAUDE.md` §1–2 and the template reference.
- Close with the touched-file list.

`components` / `core` / `navigation` / `merge_dependencies` package READMEs also point here and at `CLAUDE.md`.
