# Atelier

A local-first personal goals app — at-a-glance pockets for the things you're working on this year and this month.

A Flutter port of the "Atelier — Pockets" design prototype.

## Status

v1 — local-first, single user, Android + iOS. Persistence is on-device SQLite via Drift; no backend, no sign-in, no cloud sync.

## Features

- 2-column masonry grid of "pockets" (goal categories) with variable-height cards.
- Per-pocket year goals (north stars) and month goals.
- Star month goals to pin them to the top.
- Inline rename / delete on every goal.
- Manage mode: long-press a pocket to enter, drag to reorder, tap × to remove.
- Settings sheet: theme (light / dark), font scale (small / medium / large), reset all data.
- Dashed-border "Open" add-slot in the grid for adding new pockets.

## Tech

- Flutter 3.32, Dart 3.8
- Drift 2.31 (SQLite + codegen)
- flutter_bloc 9.1 cubits with manual `cubit.stream.listen` for tests
- go_router 16.3
- shared_preferences for settings persistence
- google_fonts (Fraunces / Inter / JetBrains Mono)
- flutter_staggered_grid_view for the masonry layout

## Architecture

Three-layer clean-architecture-lite:

```
lib/
  domain/         pure-Dart models + repository contracts
  data/           Drift schema + repository implementations + prefs
  presentation/   cubits, screens, widgets (one widget per file)
  services/       orchestrators that compose multiple repositories
  config/         composition root + go_router config
  theme/          design tokens (palette, typography, spacing, theme builders)
  utils/          small helpers (uuid, date utilities)
```

The composition root in `lib/config/atelier_app.dart` instantiates repositories and services once, then provides cubits via `MultiBlocProvider`. Each cubit reloads from disk after a mutation rather than carrying optimistic local state.

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The first build_runner run is required to generate the Drift database file (`lib/data/drift/atelier_database.g.dart`).

## Develop

```bash
tool/check.sh   # dart format + flutter analyze + flutter test
```

Strict analyzer (`strict-casts`, `strict-inference`, `strict-raw-types`) plus `flutter_lints`. Tests live in `test/` and mirror the `lib/` layout. 152 tests cover repos (with in-memory Drift), services, cubits (with manual stream listening), and key widget interactions.

## Build

The `build.yml` GitHub Actions workflow builds a debug APK for Android and an unsigned `.app` archive for iOS, both attached as artifacts to the workflow run. Trigger it from the Actions tab via "Run workflow"; choose `android`, `ios`, or `both`. Artifacts are retained for 14 days.

## Design

The original design handoff (palettes, typography, screen-by-screen breakdowns, prototype JSX) is preserved at `docs/design-handoff/`.

The architecture spec, including token tables and acceptance details, is at `docs/superpowers/specs/2026-05-02-atelier-design.md`.

## License

Private project.
