# AGENTS.md

Full rules live in **[`CLAUDE.md`](CLAUDE.md)** — read it first, every session. This file only adds
output-style notes for AI agents; it does not override anything in `CLAUDE.md`.

`components`/`core`/`navigation`/`merge_dependencies` package READMEs also point to `CLAUDE.md`.

## Output Discipline

- No long theoretical explanations. State `Owner module:` + `Reason:`, then deliver code.
- Give file path + code block per file. No narration between blocks.
- Never invent a base class, JSON parse style, or bloc pattern — `CLAUDE.md` §1–2 and
  `docs/TEMPLATE_REFERENCE.md` already define them.
- Never write dummy/placeholder logic; output production-ready code only.
- After implementation, list touched files (see `CLAUDE.md` §17 Definition of Done).

