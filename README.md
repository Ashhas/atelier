# Atelier

A local-first personal goals app — at-a-glance pockets for the things you're working on this year and this month.

A Flutter port of the "Atelier — Pockets" design prototype.

## Status

v1 — local-first, single user, Android + iOS. Persistence is on-device SQLite via Drift; no backend, no sign-in, no cloud sync.

## Features

- **Pockets for what matters.** Group your goals into pockets — Work, Body, Mind, Side projects, whatever. Each pocket holds your big goals for the year and your focus for the month, side by side.
- **A north star and a path.** Set one or more year goals per pocket so you always remember the bigger why, then add the smaller monthly goals that get you there.
- **Star what you're working on now.** Tap the star next to a goal to pin it to the top of its list, so the things you actually care about don't get lost in the pile.
- **Tap to edit, tap to delete.** No menus, no modals. Tap a goal to expand it, edit the title in place, or remove it.
- **Rearrange your home.** Long-press a pocket to enter manage mode — drag pockets into a new order, remove the ones you've outgrown, then tap anywhere outside to lock it back in.
- **A month at a glance.** A subtle tick strip at the top of the home screen shows where you are in the month, so you can feel the time passing without checking a calendar.
- **Looks the way you read.** Light and dark themes, plus three font sizes (small, medium, large) so the typography fits your eyes and your context.
- **Yours, on your device.** Everything stays on your phone — no account, no sign-in, no cloud. One tap in settings clears every goal if you want a fresh start.

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
