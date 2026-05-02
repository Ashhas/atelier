# Atelier

Personal monthly goals app — at-a-glance pockets for the things you're working on.

A Flutter port of the Claude Design "Atelier — Pockets" prototype, built for Ashhas Studio.

## Status

v1 — local-first, single user, Android + iOS.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Develop

```bash
tool/check.sh   # format + analyze + test
```

## Layout

See `docs/superpowers/specs/2026-05-02-atelier-design.md` for the architecture spec.
The original Claude Design handoff is preserved at `docs/design-handoff/`.
