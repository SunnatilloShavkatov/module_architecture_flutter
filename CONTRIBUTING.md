# Contributing Guide

Thank you for your interest in contributing to this project!

This repository follows a **strict modular Clean Architecture** approach with well-defined patterns
and conventions. Please read this document carefully before opening a Pull Request.

---
## 📐 Where the Rules Live

This file describes the **contribution process**. It deliberately does **not** repeat the coding
rules — they live in exactly one place, and a second copy would drift out of sync with the code.

| You are writing | Read this |
|---|---|
| Anything at all (start here) | [`AGENTS.md`](AGENTS.md) — the single source of truth |
| A new module, DI, container, cross-module calls | [`docs/rules/module.md`](docs/rules/module.md) |
| Entity, repository interface, usecase, interactor | [`docs/rules/domain.md`](docs/rules/domain.md) |
| Endpoint, data source, model, repository impl | [`docs/rules/data-api.md`](docs/rules/data-api.md) |
| BLoC, event, state, transformer | [`docs/rules/bloc.md`](docs/rules/bloc.md) |
| Page, mixin, widget, pagination | [`docs/rules/page-mixin.md`](docs/rules/page-mixin.md) |
| Route, args, bottom sheet, dialog | [`docs/rules/navigation.md`](docs/rules/navigation.md) |
| UI, spacing, colors, typography | [`docs/rules/ui.md`](docs/rules/ui.md) |
| User-facing text, translations | [`docs/rules/l10n.md`](docs/rules/l10n.md) |
| Unit, repository and BLoC tests | [`docs/rules/testing.md`](docs/rules/testing.md) |

Every rules file ends with a checklist and points at a **real reference file in this repository**.
Copy the reference file's style instead of inventing your own — `modules/notifications/` is the
complete 6-layer reference module.

The hard bans (`package:flutter/material.dart`, `Navigator.push`, `showDialog`, `print`, `fromJson`,
`Theme.of`, hardcoded strings and dimensions, cross-module imports, `const <ClassName>(` instead of
`const new(`) are listed in [`AGENTS.md`](AGENTS.md) §5 and most of them are enforced automatically
by `.claude/hooks/arch-guard.sh`.

---

## ✅ Before You Open a Pull Request

Run the verification gate — it is the same gate CI and the agents use:

```bash
./scripts/verify.sh
```

It runs the architecture guard, `dart format`, `dart analyze` and the tests of the modules you
touched, and finishes in under 10 seconds. For a large or architectural change run the deep pass:

```bash
./scripts/verify.sh --all
```

Useful helpers:

- `./scripts/quick_check.sh` — format + analyze only (~3s)
- `./scripts/test_module.sh <name>` — run one module's test suite
- `./scripts/create_module.sh <name>` — scaffold a new module with all layers

> **Never** run `flutter build apk` / `flutter build ios` / `gradlew` as part of a change. Builds
> take minutes and are the maintainer's call (`AGENTS.md` §5).

### Checklist

- [ ] I opened the reference file for what I was writing and copied its style.
- [ ] The relevant `docs/rules/*.md` checklist passes.
- [ ] No entry from the `AGENTS.md` §5 ban table appears in my diff.
- [ ] New or changed behaviour is covered by tests, mirroring `lib/src/` in `test/src/`.
- [ ] `./scripts/verify.sh` is green.
- [ ] The diff is minimal — no unrelated reformatting or drive-by refactors.

---

## 🔄 Contribution Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/my-feature`
3. **Follow** architecture rules and code standards
4. **Test** your changes thoroughly
5. **Commit** with clear messages: `git commit -m "feat: add user profile page"`
6. **Push** to your fork: `git push origin feature/my-feature`
7. **Open** a Pull Request with description

### Commit Message Format

```
<type>: <description>

[optional body]
[optional footer]
```

**Types**:

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples**:

```
feat: add user authentication module
fix: resolve null check error in profile page
refactor: extract common widget to components package
docs: update README with new module structure
```

---

## 📚 Additional Resources

- [`AGENTS.md`](AGENTS.md) — architecture standard, ban table, reference-file map
- [`docs/README.md`](docs/README.md) — index of all rules files
- [`docs/claude_code_setup.md`](docs/claude_code_setup.md) — AI agent setup, scripts, safety limits
- [`.claude/rules/flutter-architecture.md`](.claude/rules/flutter-architecture.md) — rules measured against the existing code
- [`.claude/rules/migration-list.md`](.claude/rules/migration-list.md) — known, accepted deviations

---

## 🆘 Getting Help

- **Architecture questions**: see [`AGENTS.md`](AGENTS.md) and [`docs/rules/`](docs/rules)
- **Code patterns**: copy the reference files listed in [`AGENTS.md`](AGENTS.md) §3
- **Issues**: Open a GitHub issue with the `question` label

---

## 🙏 Thank You

Your contributions make this project better! By following these guidelines, you help maintain code
quality, consistency, and scalability.

**Remember**:

- Clean Architecture is non-negotiable
- Domain layer stays pure — no Flutter, no JSON, no network
- BLoC calls UseCases, never repositories; BLoC holds no mutable state
- Copy the reference file instead of inventing a style
- `./scripts/verify.sh` must be green before you push

Happy coding! 🚀
