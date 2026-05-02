# Atelier — Design Spec

> Flutter port of the "Atelier — Pockets" HTML/React prototype from a Claude Design handoff. Personal monthly goals app organised into year-pockets, each holding 2026 north-stars and a list of monthly goals. Offline-first, single user, persistent local storage. The handoff bundle (README, chats, prototype source) is preserved at `docs/design-handoff/`.

## 1. Goals & non-goals

### Goals
- Pixel-faithful port of `Atelier.html` (the user's primary design from the handoff)
- At-a-glance month overview by "pockets" (areas of life)
- Offline-first persistent local storage (single user, single device)
- Light + dark themes, S/M/L font scale
- Architecture that supports adding Supabase sync later without rewiring the app

### Non-goals (for v1)
- Cloud sync, accounts, multi-device
- Month picker / browsing past or future months
- "Focused mode" parallel view of starred goals
- Notifications, reminders, recurring goals
- Goal completion / progress tracking (intentionally absent — pure glance)
- iOS-specific polish beyond what `flutter create` gives us (Android-primary per user's chat)

## 2. Source-of-truth references

- **Prototype:** `docs/design-handoff/personal-month-goals-system/project/Atelier.html` and its imports
  - `data.jsx` — sample data shape
  - `v-atelier-year.jsx` — the entire app (palettes, fonts, all components, all interactions)
- **User intent:** `docs/design-handoff/personal-month-goals-system/chats/chat1.md`
- **Brainstorming clarifications:** captured inline below

## 3. Product behaviour

### 3.1 Chrome vs. data
The chrome (header, tick strip, year-banner labels, days-left counter) reflects the **real current date** via `DateTime.now()`. The data (goals, year-goals, areas) is an ongoing list and **does not auto-archive** when the calendar rolls over. May → June changes the header but not the goals.

### 3.2 Areas (pockets)
- Default seed on first launch: `Work`, `Body`, `Mind`, `Skill`, `Daily`, `Play`, `Life`, plus a single `Open` add-slot pocket pinned at the end.
- Areas are **fully user-customizable**: rename, add new, reorder, remove. The `Open` pocket cannot be removed, reordered, or renamed.
- "Add new area" replaces the prototype's empty-state copy on the `Open` pocket — tapping it opens a small input.
- Removing an area cascade-deletes all its goals and year-goals.

### 3.3 Goals
- **Month goals** are an ongoing list, not bucketed by month. Each goal has a `title`, `starred` flag, and `addedAt` timestamp.
- **Star** is purely visual emphasis. Unlimited stars allowed. Starred goals **always sort to the top** of both the home pocket preview and the detail list. Within starred and within unstarred groups, sort is **insertion order** (oldest first).
- The "days since added" label on each detail row uses `DateTime.now().difference(addedAt).inDays`. `0` → "today", `1` → "1 day", else `"{n} days"`.

### 3.4 Year goals (north-stars)
- Independent list per area. No completion, no progress.
- Banner label reads `"{currentYear} · NORTH STAR"` — year derived from `DateTime.now()`. The year is just chrome; year goals do not auto-archive.
- Each banner has an `expanded` state (collapsed = compact one-liner, expanded = full italic title) persisted across launches.
- Removable via × on the expanded banner.

### 3.5 Add bar (detail screen)
- Bottom floating bar with a segmented switch labelled `"MONTH" / "YEAR"` (simple labels, not derived month names).
- Tapping `+ Add to {area or year}` opens an inline input. Enter submits; Esc / blur with empty value cancels; blur with content submits.

### 3.6 Manage mode (home)
- Long-press any non-Open pocket for ~450ms → enters manage mode.
- All non-Open pockets wiggle (rotate -0.5° ↔ 0.5° infinite alternate, ~150ms).
- Each shows a × button at top-left.
- Pockets become drag-reorderable; drop target highlights with an inked border.
- The `Open` pocket disappears entirely from the grid while in manage mode.
- Tap outside any pocket OR tap the `Done` pill in the top-right → exits manage mode.

### 3.7 Settings
- Bottom sheet with backdrop, slide-up animation.
- Theme: Light / Dark segmented control.
- Font scale: Small / Medium / Large segmented control (multipliers 0.92, 1.0, 1.10).
- "Reset all data" with two-step confirm — clears all Hive boxes + SharedPreferences and re-seeds default areas.

### 3.8 Tick strip
- 28 / 30 / 31 vertical ticks for the current month. Today's tick is `2px` wide, full height (14px), painted with the accent colour.
- Other ticks: major (every 5th + day 1 + last day) `6px` tall, minor `3px` tall, all `1px` wide on the rule colour.
- Above today's tick: a small mono caps label `D{day} · {pct}%` where `pct = round((day / daysInMonth) * 100)`. Day number bold in ink, percentage muted.

## 4. Architecture

```
┌─ UI Layer (Flutter widgets) ─────────────────────┐
│  HomeScreen, DetailScreen, SettingsSheet         │
│  Pocket, GoalRow, YearBanner, TickStrip,         │
│  AddBar, Segmented, MonoLabel, SerifTitle        │
└──────────────────┬───────────────────────────────┘
                   │ ref.watch / ref.read
┌──────────────────▼───────────────────────────────┐
│  Riverpod providers                              │
│  themeProvider, fontScaleProvider                │
│  areasProvider, goalsProvider, yearGoalsProvider │
└──────────────────┬───────────────────────────────┘
                   │ injects
┌──────────────────▼───────────────────────────────┐
│  Repository interfaces (abstract)                │
│  GoalRepository, AreaRepository,                 │
│  YearGoalRepository, SettingsRepository          │
└──────────────────┬───────────────────────────────┘
                   │ implemented by
┌──────────────────▼───────────────────────────────┐
│  HiveGoalRepository, HiveAreaRepository,         │
│  HiveYearGoalRepository, PrefsSettingsRepository │
│  (future: SupabaseGoalRepository, etc.)          │
└──────────────────────────────────────────────────┘
```

**Key design choices:**

- **Repository pattern** — `abstract class GoalRepository` defines `Future<List<Goal>> all()`, `add(Goal)`, `update(Goal)`, `delete(String id)`, etc. The Hive impl ships v1; a Supabase impl can drop in later by implementing the same interface.
- **Riverpod over setState/Provider** — the prototype's giant `AtelierYear` component with 8 useState calls maps poorly to a single Flutter widget. Riverpod splits state into focused providers that widgets subscribe to selectively.
- **Hive for goals/areas/year-goals** — fast, typed, offline. SharedPreferences for theme + font scale (small key/value).
- **UUID v4 string ids** — stable across devices in case of future sync.
- **`go_router`** — two routes (`/`, `/area/:id`); built-in deep-link friendliness for later Android intent integration.
- **`google_fonts`** — Fraunces (display, italic), Inter (sans, primary UI), JetBrains Mono (mono, all small-caps labels). Matches prototype's CDN imports.
- **`reorderable_grid_view`** package — handles 2-column drag-reorder for the pocket grid.

## 5. Data model

```dart
class Area {
  final String id;          // uuid
  final String name;        // user-editable display name
  final int order;          // 0..N for sort
  final bool isAddSlot;     // true for the single "Open" pocket
}

class Goal {
  final String id;          // uuid
  final String areaId;      // FK → Area.id
  final String title;
  final bool starred;
  final DateTime addedAt;
}

class YearGoal {
  final String id;
  final String areaId;      // FK → Area.id
  final String title;
  final bool expanded;
}

enum FontScale { small, medium, large }

class AppSettings {
  final ThemeMode themeMode;
  final FontScale fontScale;
}
```

**Notes:**
- Goals/year-goals reference `areaId`, not name — renaming an area doesn't orphan its goals.
- `isAddSlot` makes the `Open` pocket a real database row (one per install) so order and uniqueness are enforced uniformly. It cannot be deleted, renamed, or reordered.
- No `month` / `year` fields on goals — they are ongoing per the chrome-vs-data rule.

## 6. Theming

Two palettes encoded exactly from `v-atelier-year.jsx`:

```dart
class AtelierColors {
  static const light = AtelierPalette(
    bg: Color(0xFFFFFFFF), ink: Color(0xFF0A0A0A),
    sub: Color(0xFF525252), mute: Color(0xFFA3A3A3),
    rule: Color(0xFFEDEDED), ruleHi: Color(0xFF0A0A0A),
    accent: Color(0xFF0A0A0A),
    chip: Color(0xFFFAFAFA), pocket: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFAFA),
    starBg: Color(0xFFEDEDED), starBorder: Color(0xFFDCDCDC),
    starInk: Color(0xFF0A0A0A),
    yearBg: Color(0xFFF5F5F2), yearInk: Color(0xFF0A0A0A),
  );
  static const dark = AtelierPalette(
    bg: Color(0xFF121212), ink: Color(0xFFFFFFFF),
    sub: Color(0xFFA7A7A7), mute: Color(0xFF727272),
    rule: Color(0xFF2A2A2A), ruleHi: Color(0xFFFFFFFF),
    accent: Color(0xFF1ED760),
    chip: Color(0xFF1F1F1F), pocket: Color(0xFF181818),
    surface: Color(0xFF181818),
    starBg: Color(0xFF282828), starBorder: Color(0xFF3E3E3E),
    starInk: Color(0xFFFFFFFF),
    yearBg: Color(0xFF181818), yearInk: Color(0xFFFFFFFF),
  );
}
```

Font scale wraps the app subtree in a `MediaQuery` override of `textScaler` (S=0.92, M=1.0, L=1.10).

## 7. Screens & components

### Screens
- `HomeScreen` — top bar (`{Month}` italic + year mono + days-left + settings gear), tick strip, 2-col pocket grid.
- `DetailScreen` — top bar (back arrow + area title + count), year-banner stack, "THIS MONTH" header, goal list, floating add bar.
- `SettingsSheet` — modal bottom sheet (theme, font scale, reset).

### Reusable widgets
- `Pocket` — single grid card. Renders top label + count, year preview (up to 2 visible expanded year goals + counts), then up to 3 month goals (starred styled distinctly) with "+N more" overflow. Long-press → `onLongPress` callback. Empty state for areas with no items, "Open · add" copy for the add slot.
- `GoalRow` — star icon, serif title, days-since-added mono label. Tap → toggle expanded action row (Edit / Remove). Edit → inline text input with Save / Cancel.
- `YearBanner` — compact (one-line italic) ↔ expanded (full italic title + × remove). Tap header → toggle.
- `TickStrip` — paints ticks for current month with today highlight + label.
- `AddBar` — segmented MONTH/YEAR switch + "+ Add to …" placeholder that becomes a TextField on tap.
- `Segmented` — generic 2/3-option pill switch (used by AddBar, theme, font scale).
- `MonoLabel`, `SerifTitle` — typography helpers.

## 8. Interactions / data flow

- **Add goal:** detail screen tap "+ Add" → input opens → Enter or blur with content → `goalsProvider.add(...)` → repo persist → list refreshes (sorted starred-first then insertion).
- **Toggle star:** tap star icon → `goalsProvider.toggleStar(id)` → re-sort → re-render.
- **Reorder pockets:** manage mode + drag → `ReorderableGridView` calls `areasProvider.reorder(from, to)` → bulk update of `order` → persist.
- **Remove area:** manage × → `areasProvider.remove(areaId)` → cascade-delete goals + year-goals in a single Hive transaction.
- **Year-banner toggle:** tap → `yearGoalsProvider.toggleExpand(id)` → persist.
- **Theme / font scale:** segmented tap → `settingsProvider.set(...)` → SharedPreferences write-through → MaterialApp rebuilds with new theme.
- **Reset:** confirm → clear all Hive boxes + prefs → re-seed default areas → return to home.

## 9. Error handling & edge cases

- **First launch:** Hive boxes empty → seed 8 default areas (Work, Body, Mind, Skill, Daily, Play, Life, Open) with order 0..7. No sample goals.
- **Empty pocket:** "Empty" placeholder (or "Open · add" for the add slot).
- **Empty detail:** dashed "No year goal yet for {area}" + "Nothing this month yet".
- **Empty input:** discarded silently.
- **Hive write failure:** SnackBar with retry; in-memory state preserved so the app stays usable. App reads through cache provider that updates on write success.
- **Cascade delete safety:** wrapped in a single `Future` that completes only after all 3 box ops succeed; on failure, full rollback (delete the in-progress changes from in-memory state).
- **System theme override:** v1 ignores `MediaQuery.platformBrightness`; theme is user-chosen. Default = light (matches prototype's initial state).

## 10. Testing strategy

- **Unit tests** — each repository: CRUD round-trip, order preservation, cascade delete on area removal, seed-on-empty idempotency, reset clears everything.
- **Provider tests** — sort order (starred-first then insertion), reorder math, toggle-star, cascade delete propagation through providers.
- **Widget tests** — Pocket renders preview correctly with starred items styled; manage-mode entry / exit / × cascade; tick strip computes today's position and label; settings sheet wires up to providers; detail add bar switches month↔year target.
- **Golden tests** — light + dark renders of HomeScreen and DetailScreen at fixed phone dimensions to catch palette / typography regressions.
- **Excluded from v1** — integration tests; covered by golden + widget tests across providers.

## 11. Project layout

```
atelier/
  lib/
    main.dart
    app.dart                    # MaterialApp.router + theme switching
    routing.dart                # go_router config
    theme/
      colors.dart               # AtelierPalette + light/dark
      typography.dart           # font helpers (Fraunces, Inter, JetBrains Mono)
      app_theme.dart            # ThemeData builders
    domain/
      area.dart
      goal.dart
      year_goal.dart
      app_settings.dart
    data/
      repositories/
        area_repository.dart            # abstract
        goal_repository.dart
        year_goal_repository.dart
        settings_repository.dart
      hive/
        hive_area_repository.dart
        hive_goal_repository.dart
        hive_year_goal_repository.dart
        prefs_settings_repository.dart
        boxes.dart                       # box names + init
        adapters.dart                    # TypeAdapters
      seed.dart                          # default-areas seeding
    state/
      providers.dart                     # repo provider injection
      areas_provider.dart
      goals_provider.dart
      year_goals_provider.dart
      settings_provider.dart
    features/
      home/
        home_screen.dart
        widgets/
          pocket.dart
          tick_strip.dart
          home_top_bar.dart
      detail/
        detail_screen.dart
        widgets/
          goal_row.dart
          year_banner.dart
          add_bar.dart
      settings/
        settings_sheet.dart
    widgets/
      segmented.dart
      mono_label.dart
      serif_title.dart
  test/
    repositories/
    providers/
    widgets/
    golden/
  docs/
    design-handoff/                       # original prototype + chats
    superpowers/specs/                    # this file
```

## 12. Build sequence (rough)

1. Theme + typography + base widgets (Segmented, MonoLabel, SerifTitle)
2. Domain models + repository interfaces
3. Hive setup (adapters, boxes, init) + Hive impls + seed-on-empty
4. SharedPreferences settings repo
5. Riverpod providers wired to repos
6. HomeScreen scaffold + TickStrip + Pocket (read-only first)
7. DetailScreen scaffold + YearBanner + GoalRow + AddBar
8. SettingsSheet
9. Manage mode (long-press, wiggle, drag-reorder, ×, cascade)
10. Tests: unit, widget, golden

The detailed breakdown lives in the implementation plan (next document).

## 13. Future considerations (deferred, noted for context)

- **Supabase sync** — implement `Supabase{Goal,Area,YearGoal}Repository` against the same interfaces; swap providers via a runtime flag or build flavour.
- **Focused mode** — global "starred only" view across pockets.
- **Month override (debug)** — hidden setting to override `DateTime.now()` for testing chrome rollover.
- **Notifications / reminders** — opt-in, per-goal.
- **Widgets** — Android home screen widget showing today's tick + days-left.
