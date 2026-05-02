# Atelier — Design Spec

> Flutter port of the "Atelier — Pockets" HTML/React prototype from a Claude Design handoff. Personal monthly goals app organised into year-pockets, each holding 2026 north-stars and a list of monthly goals. Offline-first, single user, persistent local storage. The handoff bundle (README, chats, prototype source) is preserved at `docs/design-handoff/`.
>
> **Owner:** Ashhas Studio. Application ID / iOS bundle identifier: `studio.ashhas.atelier`. Android namespace + Kotlin package: `studio.ashhas.atelier`.

## 1. Goals & non-goals

### Goals
- Pixel-faithful port of `Atelier.html` (the user's primary design from the handoff)
- At-a-glance month overview organised into pockets (each pocket holds one goal category — Work, Body, Mind, etc.)
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
The chrome (header, tick strip, year-banner labels, days-left counter) reflects the **real current date** via `DateTime.now()`. The data (goals, year-goals, goal categories) is an ongoing list and **does not auto-archive** when the calendar rolls over. May → June changes the header but not the goals.

### 3.2 Goal categories (rendered as pockets)

Terminology: in code and data the model is called a **`GoalCategory`**. In the UI it is rendered as a **pocket** card on the home grid, and that is the word used in user-facing copy.

- **No seeded defaults.** First launch starts with an empty database — no goal categories, no `Open` pocket, no goals. Home renders a dedicated empty state (see §3.9).
- The `Open` add-slot pocket is created lazily the first time the user adds a real pocket, and persists from then on.
- Pockets are **fully user-customizable**: rename, add new, reorder, remove. The `Open` pocket cannot be removed, reordered, or renamed.
- Tapping the `Open` pocket opens a small input ("New pocket name…"). Submit creates a new `GoalCategory` row.
- Removing a pocket cascade-deletes all its goals and year-goals. If the user removes their last real pocket, home reverts to the empty state and the `Open` pocket is also removed.

### 3.3 Goals
- **Month goals** are an ongoing list, not bucketed by month. Each goal has a `title`, `starred` flag, and `addedAt` timestamp.
- **Star** is purely visual emphasis. Unlimited stars allowed. Starred goals **always sort to the top** of both the home pocket preview and the detail list. Within starred and within unstarred groups, sort is **insertion order** (oldest first).
- The "days since added" label on each detail row uses `DateTime.now().difference(addedAt).inDays`. `0` → "today", `1` → "1 day", else `"{n} days"`.

### 3.4 Year goals (north-stars)
- Independent list per pocket. No completion, no progress.
- Banner label reads `"{currentYear} · NORTH STAR"` — year derived from `DateTime.now()`. The year is just chrome; year goals do not auto-archive.
- Each banner has an `expanded` state (collapsed = compact one-liner, expanded = full italic title) persisted across launches.
- Removable via × on the expanded banner.

### 3.5 Add bar (detail screen)
- Bottom floating bar with a segmented switch labelled `"MONTH" / "YEAR"` (simple labels, not derived month names).
- Tapping `+ Add to {pocket name or year}` opens an inline input. Enter submits; Esc / blur with empty value cancels; blur with content submits.

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
- "Reset all data" with two-step confirm — truncates all Drift tables and clears SharedPreferences. Home returns to the blank-slate empty state.

### 3.9 First-launch / blank-slate empty state

When the goal-categories list is empty, `HomeScreen` renders `HomeEmptyState` in place of the pocket grid. The chrome (`HomeTopBar` with month/year, `DaysLeftLabel`, `SettingsGearButton`, plus `TickStrip`) **stays visible** — the app should still tell you "today is May 2 · 29 days left" from second one.

Composition (built from the existing design vocabulary — dashed hairline borders, JetBrains Mono small-caps eyebrows, Fraunces italic display, Inter sans body, the existing ink-pill button style):

- A large dashed-border container occupying the region where the grid normally sits: `1px dashed C.rule`, `borderRadius: 14`, full width with the same 22px horizontal padding as the grid, vertical padding ~28px.
- Vertically and horizontally centered content stack (gap 14px):
  - **Eyebrow** — plain `Text('BLANK SLATE', style: AtelierTypography.monoEyebrow.copyWith(color: C.mute))`. Tokens live in `theme/atelier_typography.dart`; per-call-site variation (color, occasional size) uses `.copyWith()`.
  - **Italic display title** — plain `Text('Your year, one pocket at a time.', style: AtelierTypography.serifDisplay.copyWith(fontSize: 26, height: 1.2, color: C.ink))`. Max-width constrained so it wraps to two lines.
  - **Sans body** — Inter 13px, `C.sub`, `lineHeight 1.4`, max-width ~240px, centered: `Pockets are categories for your goals — Work, Body, Mind, anything you want. Tap below to start your first one.`
  - **Primary action** — pill button matching the existing `C.ink` "Done" pill in manage mode, scaled slightly: `+ ADD YOUR FIRST POCKET` in JetBrains Mono caps 10px / letter-spacing 1.4 / weight 600, `padding 12px 18px`, `borderRadius 999`, `background: C.ink`, `color: C.bg`.
- Tapping the action button enters the same add-pocket flow as tapping `Open` (small input → submit → create `GoalCategory`). On the first successful add: also create the `Open` add-slot row, then home transitions to the normal grid view.
- The settings gear remains active in the empty state so theme / font scale can be set before adding the first pocket.
- `HomeEmptyState` gets its own widget file at `lib/presentation/features/home/widgets/empty_state/home_empty_state.dart`, with sub-components in the same folder (`home_empty_state_eyebrow.dart`, `home_empty_state_body.dart`, `home_empty_state_action.dart`) per the one-widget-per-file rule.

### 3.8 Tick strip
- 28 / 30 / 31 vertical ticks for the current month. Today's tick is `2px` wide, full height (14px), painted with the accent colour.
- Other ticks: major (every 5th + day 1 + last day) `6px` tall, minor `3px` tall, all `1px` wide on the rule colour.
- Above today's tick: a small mono caps label `D{day} · {pct}%` where `pct = round((day / daysInMonth) * 100)`. Day number bold in ink, percentage muted.

## 4. Architecture

```
┌─ UI Layer (Flutter widgets) ─────────────────────┐
│  HomeScreen, DetailScreen, SettingsSheet         │
│  Pocket, GoalRow, YearBanner, TickStrip,         │
│  AddBar, Segmented (plus stock Text + theme styles)│
└──────────────────┬───────────────────────────────┘
                   │ context.read / BlocBuilder / BlocSelector
┌──────────────────▼───────────────────────────────┐
│  Cubits (flutter_bloc, no events — methods only) │
│  GoalCategoriesCubit, GoalsCubit, YearGoalsCubit,         │
│  SettingsCubit, ManageModeCubit (UI-only)        │
└──────────────────┬───────────────────────────────┘
                   │ injects via constructor (DI at app root)
┌──────────────────▼───────────────────────────────┐
│  Repository interfaces (abstract)                │
│  GoalRepository, GoalCategoryRepository,                 │
│  YearGoalRepository, SettingsRepository          │
└──────────────────┬───────────────────────────────┘
                   │ implemented by
┌──────────────────▼───────────────────────────────┐
│  DriftGoalRepository, DriftGoalCategoryRepository,       │
│  DriftYearGoalRepository, PrefsSettingsRepository│
│  (future: SupabaseGoalRepository, etc.)          │
└──────────────────────────────────────────────────┘
```

**Key design choices:**

- **Repository pattern** — `abstract class GoalRepository` defines `Future<List<Goal>> all()`, `add(Goal)`, `update(Goal)`, `delete(String id)`, etc. The Drift impl ships v1; a Supabase impl can drop in later by implementing the same interface.
- **flutter_bloc with Cubits (no events)** — the prototype's giant `AtelierYear` component with 8 useState calls maps poorly to a single Flutter widget. Cubits split state into focused units that widgets subscribe to via `BlocBuilder` / `BlocSelector`. No event classes — Cubits expose plain methods (`addGoal`, `toggleStar`, `reorderArea`) that emit new state. Equivalent reactive model, less boilerplate than full Bloc.
- **State immutability** — each Cubit's state is an immutable class (`Equatable`-based) holding the slice it owns. Lists inside states are unmodifiable. `emit` always produces a new instance.
- **DI at app root** — repositories are constructed once in `main.dart`, then injected into Cubits via `MultiBlocProvider` at the top of the widget tree. No service locator (`get_it` / `provider`) in v1.
- **Drift (SQLite) for goals/goal_categories/year-goals** — type-safe SQL with codegen, actively maintained, strong story for migrating to Supabase later (Supabase is Postgres; Drift's table definitions and queries map nearly one-for-one). Native ordering / filtering via SQL is a better fit than NoSQL hand-sorting for our starred-first + insertion-order requirement. SharedPreferences for theme + font scale (small key/value).
- **UUID v4 string ids** — stable across devices in case of future sync.
- **`go_router`** — two routes (`/`, `/pocket/:id`); built-in deep-link friendliness for later Android intent integration.
- **`google_fonts`** — Fraunces (display, italic), Inter (sans, primary UI), JetBrains Mono (mono, all small-caps labels). Matches prototype's CDN imports.
- **`reorderable_grid_view`** package — handles 2-column drag-reorder for the pocket grid.

## 5. Data model

```dart
class GoalCategory {
  final String id;          // uuid
  final String name;        // user-editable display name (rendered as the pocket label)
  final int order;          // 0..N for sort
  final bool isAddSlot;     // true for the single "Open" pocket
}

class Goal {
  final String id;          // uuid
  final String goalCategoryId;      // FK → GoalCategory.id
  final String title;
  final bool starred;
  final DateTime addedAt;
}

class YearGoal {
  final String id;
  final String goalCategoryId;      // FK → GoalCategory.id
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
- Goals/year-goals reference `goalCategoryId`, not name — renaming a pocket doesn't orphan its goals.
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

### Coding rules (apply to every file in this project)

- **One widget per file.** No private helper widgets, no nested widget classes, no inline `Builder` / `LayoutBuilder` definitions of named widgets. Every named widget — public *or* internal — gets its own file. The file name is the snake-case form of the widget class name (e.g. `pocket_year_preview.dart` → `class PocketYearPreview`).
- **Files import widgets explicitly.** A screen composes by importing each child widget; no widget defines its children inline as new classes in the same file.
- **Stateful → stateless split.** When a widget needs local UI state, it owns a `StatefulWidget` + `State` pair in the same file. Anything that's purely a view → `StatelessWidget`. State that crosses widgets → a Cubit.
- **No anonymous functions defining UI structure beyond trivial.** A simple `IconButton(onPressed: () => cubit.toggle(...))` is fine. A `Builder` returning 30 lines of layout is not — extract it to its own file.


### Screens
- `HomeScreen` — top bar (`{Month}` italic + year mono + days-left + settings gear), tick strip, 2-col pocket grid.
- `DetailScreen` — top bar (back arrow + pocket name + count), year-banner stack, "THIS MONTH" header, goal list, floating add bar.
- `SettingsSheet` — modal bottom sheet (theme, font scale, reset).

### Reusable widgets (each in its own file under the path implied by Section 11)

The full widget breakdown lives in the project layout (Section 11). Roles in brief:

- **Home grid** — `Pocket` composes `PocketHeader`, `PocketYearPreview`, `PocketGoalsPreview`, `PocketRemoveBadge`, `PocketEmptyState`. `PocketGrid` wraps `ReorderableGridView` and handles drag-reorder. When the goal-categories list is empty, `HomeScreen` swaps the grid for `HomeEmptyState` (composed of `HomeEmptyStateEyebrow`, `HomeEmptyStateBody`, `HomeEmptyStateAction`); chrome (top bar + tick strip) is unchanged.
- **Home top bar** — `HomeTopBar` composes the month/year title, `DaysLeftLabel`, and either `SettingsGearButton` or `DonePillButton` depending on manage mode.
- **Tick strip** — `TickStrip` composes `TickStripBaseline`, one `TickStripTickMark` per day of the current month, and a `TickStripTodayLabel` above today's tick.
- **Detail goals** — `GoalRow` composes `GoalRowStarButton`, the serif title, `GoalRowDaysLabel`, and conditionally renders `GoalRowActions` (when expanded) or `GoalRowEditor` (when editing). `GoalsEmptyState` for empty list.
- **Detail year banners** — `YearBanner` switches between `YearBannerCollapsed` and `YearBannerExpanded`. `YearBannerEmptyState` when none exist for the pocket.
- **Detail add bar** — `AddBar` composes `AddBarSwitch` (uses `Segmented`) plus either `AddBarInput` or `AddBarPlaceholder`.
- **Detail top bar** — `DetailTopBar` composes `DetailBackButton` + serif title + `DetailCountLabel`.
- **Settings sheet** — `SettingsSheet` composes `SettingsBackdrop`, `SettingsHandle`, `SettingsHeader`, `ThemeSelector`, `FontScaleSelector`, and `ResetDataButton`. The button swaps to `ResetDataConfirm` after first tap.
- **Common atoms** — `Segmented` + `SegmentedOption` (the generic pill switch). No custom text widgets: every label / title / body uses `Text(...)` with a named `TextStyle` constant from `theme/atelier_typography.dart`, with `.copyWith()` for the rare per-site variation (color, size). The status-bar inset is handled by Flutter's stock `SafeArea`.

## 8. Interactions / data flow

- **Add goal:** detail screen tap "+ Add" → input opens → Enter or blur with content → `context.read<GoalsCubit>().add(...)` → repo persist → Cubit emits new state → list refreshes (sorted starred-first then insertion).
- **Toggle star:** tap star icon → `GoalsCubit.toggleStar(id)` → re-sort → emit → re-render.
- **Reorder pockets:** manage mode + drag → `ReorderableGridView` calls `GoalCategoriesCubit.reorder(from, to)` → bulk update of `order` → persist → emit.
- **Remove pocket:** manage × → `GoalCategoriesCubit.remove(goalCategoryId)` triggers a transactional cascade that also calls into `GoalsCubit` and `YearGoalsCubit` to drop their entries (or, simpler, repos cascade and all three cubits reload from disk after the call).
- **Year-banner toggle:** tap → `YearGoalsCubit.toggleExpand(id)` → persist → emit.
- **Theme / font scale:** segmented tap → `SettingsCubit.setTheme(...)` / `setFontScale(...)` → SharedPreferences write-through → emit → `BlocBuilder` at the `MaterialApp.router` level rebuilds with new `ThemeData`.
- **Reset:** confirm → all Drift tables truncated + prefs cleared → all cubits `reload()` → emit fresh states → home re-renders the empty state (no re-seed, matches first-launch behaviour).
- **Manage mode:** `ManageModeCubit` is a tiny UI-only cubit holding `bool isManaging` (and optionally drag state). HomeScreen reads it via `BlocBuilder`. Long-press → `enter()`, tap-outside / Done → `exit()`. Not persisted.

## 9. Error handling & edge cases

- **First launch:** Drift `goal_categories` table empty → no seeding. Home renders `HomeEmptyState` (see §3.9). The first user-added pocket lazily creates both the `GoalCategory` row and the pinned `Open` add-slot row in the same transaction.
- **Empty pocket:** "Empty" placeholder (or "Open · add" for the add slot).
- **Empty detail:** dashed "No year goal yet for {pocket name}" + "Nothing this month yet".
- **Empty input:** discarded silently.
- **Drift write failure:** SnackBar with retry; Cubit state preserved so the app stays usable. Cubits reload from disk after any write to stay consistent.
- **Cascade delete safety:** wrapped in a Drift `transaction { }` block — pocket + its goals + its year-goals deleted atomically. On failure, the transaction rolls back at the DB level; cubits reload to clear any optimistic state.
- **System theme override:** v1 ignores `MediaQuery.platformBrightness`; theme is user-chosen. Default = light (matches prototype's initial state).

## 10. Testing strategy

- **Unit tests** — each repository: CRUD round-trip, order preservation, cascade delete on pocket removal, first-add transaction creates both the `GoalCategory` and the `Open` slot, reset clears everything (and home transitions back to empty state).
- **Cubit tests** — using `bloc_test`: sort order emitted on state change (starred-first then insertion), reorder math, toggle-star, cascade delete propagation across the three goal-related cubits, settings cubit emits on theme/font-scale change, manage-mode cubit toggles correctly.
- **Widget tests** — Pocket renders preview correctly with starred items styled; manage-mode entry / exit / × cascade; tick strip computes today's position and label; settings sheet wires up to cubits; detail add bar switches month↔year target. Use `BlocProvider.value` with mock cubits in tests.
- **Golden tests** — light + dark renders of HomeScreen and DetailScreen at fixed phone dimensions to catch palette / typography regressions.
- **Excluded from v1** — integration tests; covered by golden + widget tests across providers.

## 11. Project layout

Three top-level layers (`domain/`, `data/`, `presentation/`) plus `config/`, `theme/`, `services/`, `utils/`. Cubits live in `state/` inside the feature that owns them, and are provided at the app-shell level for cross-feature access — patterned after the Plastic-Avengers convention of feature-scoped state with shell-level provision.

```
atelier/
  lib/
    main.dart                                # entrypoint: bootstrap DB + prefs, run AtelierApp
    config/
      atelier_app.dart                       # MaterialApp.router + MultiBlocProvider (composition root)
      router.dart                            # go_router config
    theme/
      atelier_palette.dart                   # AtelierPalette type
      atelier_colors.dart                    # light + dark palette constants
      atelier_typography.dart                # TextStyle tokens — Fraunces / Inter / JetBrains Mono
      atelier_theme.dart                     # ThemeData builders for light + dark

    domain/
      models/
        goal_category.dart                   # plain immutable data class
        goal.dart
        year_goal.dart
        app_settings.dart
        enums/
          font_scale.dart
      repositories/                          # CONTRACTS only — abstract classes
        goal_category_repository.dart
        goal_repository.dart
        year_goal_repository.dart
        settings_repository.dart

    data/
      drift/
        atelier_database.dart                # @DriftDatabase root
        tables/
          goal_categories_table.dart
          goals_table.dart
          year_goals_table.dart
      repositories/                          # IMPLEMENTATIONS only
        drift_goal_category_repository.dart  # implements GoalCategoryRepository
        drift_goal_repository.dart           # implements GoalRepository
        drift_year_goal_repository.dart      # implements YearGoalRepository
        prefs_settings_repository.dart       # implements SettingsRepository
      # future: data/supabase/, data/cache/, etc.

    services/
      open_slot_creator.dart                 # orchestrator — composes repository calls;
                                             # creates the Open add-slot row on first pocket add
      # future: notification_service.dart, analytics_service.dart, etc.

    presentation/
      features/
        home/
          home_container.dart                # builds HomeScreen; reads cubits from app-shell BlocProvider
          home_screen.dart                   # pure UI, reads via BlocBuilder
          state/
            goal_categories_cubit.dart       # owns the goal-categories list (CRUD + reorder).
            goal_categories_state.dart       # provided at app-shell level; consumed by home + detail + settings.
            manage_mode_cubit.dart           # UI-only manage-mode state (home-only)
            manage_mode_state.dart
          widgets/
            top_bar/
              home_top_bar.dart
              days_left_label.dart
              settings_gear_button.dart
              done_pill_button.dart
            tick_strip/
              tick_strip.dart
              tick_strip_baseline.dart
              tick_strip_tick_mark.dart
              tick_strip_today_label.dart
            pocket/
              pocket.dart
              pocket_header.dart
              pocket_year_preview.dart
              pocket_goals_preview.dart
              pocket_remove_badge.dart
              pocket_empty_state.dart
            grid/
              pocket_grid.dart               # ReorderableGridView wrapper
            empty_state/
              home_empty_state.dart          # rendered when goal-categories list is empty
              home_empty_state_eyebrow.dart
              home_empty_state_body.dart
              home_empty_state_action.dart
        detail/
          detail_container.dart              # builds DetailScreen; reads cubits from app-shell BlocProvider
          detail_screen.dart
          state/
            goals_cubit.dart                 # owns the goals list (CRUD + star + sort).
            goals_state.dart                 # provided at app-shell level; consumed by home (preview) + detail (full list).
            year_goals_cubit.dart            # owns year goals (CRUD + expand toggle).
            year_goals_state.dart            # provided at app-shell level; consumed by home (preview) + detail (banners).
          widgets/
            top_bar/
              detail_top_bar.dart
              detail_back_button.dart
              detail_count_label.dart
            year_banner/
              year_banner.dart
              year_banner_collapsed.dart
              year_banner_expanded.dart
              year_banner_empty_state.dart
            goals/
              goal_row.dart
              goal_row_actions.dart
              goal_row_editor.dart
              goal_row_star_button.dart
              goal_row_days_label.dart
              goals_empty_state.dart
            add_bar/
              add_bar.dart
              add_bar_switch.dart
              add_bar_input.dart
              add_bar_placeholder.dart
        settings/
          settings_sheet.dart                # the shell — modal bottom sheet
          state/
            settings_cubit.dart
            settings_state.dart
          widgets/
            settings_handle.dart
            settings_backdrop.dart
            settings_header.dart
            theme_selector.dart
            font_scale_selector.dart
            reset_data_button.dart
            reset_data_confirm.dart
      common/                                # shared UI atoms
        segmented/
          segmented.dart
          segmented_option.dart

    utils/
      date_utils.dart                        # daysInMonth, daysSince helpers
      uuid.dart                              # uuid v4 wrapper

  test/
    domain/
      repositories/                          # contract conformance helpers (shared test fixtures)
    data/
      drift/                                 # repo impl tests against a real Drift DB
      repositories/                          # prefs impl tests
    services/                                # open_slot_creator tests
    presentation/
      features/
        home/
          state/
          widgets/
        detail/
          state/
          widgets/
        settings/
          state/
          widgets/
      common/
    golden/

  docs/
    design-handoff/                          # original prototype + chats
    superpowers/specs/                       # this file
```

**Notes on layout choices — three-layer clean-architecture-lite:**

The top of `lib/` splits into seven folders, each with a single sharp responsibility:

| Folder | Owns | Knows |
|---|---|---|
| `domain/` | Models + repository contracts (abstract classes) | Nothing outside itself. Pure Dart, no Flutter, no Drift, no Bloc. |
| `data/` | Repository implementations + DB schema | Knows `domain/` (implements its contracts). Knows Drift / SharedPreferences. |
| `services/` | Orchestrators that compose multiple repositories | Knows `domain/` (depends on contracts, not impls). |
| `presentation/` | Cubits, screens, widgets | Knows `domain/` (consumes contracts via DI). Does NOT know `data/`. |
| `config/` | App shell, routing, composition root | The only place that imports from `data/` and constructs concrete repository impls; injects them into cubits via `MultiBlocProvider`. |
| `theme/` | Visual tokens (palettes, `TextStyle` constants, `ThemeData` builders) | Pure values; no logic. |
| `utils/` | Pure helpers (`uuid`, date math) | No deps on anything domain-specific. |

Dependency direction (one-way, top-down):

```
config ──▶ data ──▶ domain ◀── services ◀── presentation
                              ▲
                              └────── presentation also depends on domain
```

`data/`, `services/`, and `presentation/` all depend on `domain/` (they implement / consume its contracts). They do **not** depend on each other.

**Why this layout:**

- The "domain doesn't know about data" rule is enforced by directory structure, not just discipline. An import of `package:atelier/data/...` from inside `lib/domain/` is immediately visible as wrong.
- Future Supabase port: write `data/supabase/supabase_*_repository.dart`, change one line in `config/atelier_app.dart` to inject the new impl. `domain/` and `presentation/` don't change.
- `data/drift/` holds *only* the DB schema (database root + tables). Drift-backed repository impls live under `data/repositories/` next to the prefs impl, because they're peers — both implement contracts from `domain/repositories/`. This keeps "what the database is" separate from "how a repository talks to it" while still letting Drift impls live in the same top-level `data/` umbrella.
- `services/` is reserved for *orchestrators* — code that composes calls across multiple repositories. Today that's just `open_slot_creator.dart`. Tomorrow it might be `notification_service.dart`, `sync_service.dart`, etc. They explicitly are not repositories.
- `theme/atelier_typography.dart` is the single source of truth for type. It exports named `TextStyle` constants (e.g. `AtelierTypography.monoEyebrow`, `serifDisplay`, `serifTitle`, `serifBody`, `sansBody`) covering every recurring recipe in the prototype. Call sites use `Text('...', style: AtelierTypography.X.copyWith(color: C.mute))` directly — no wrapper widgets. This keeps tokens discoverable via autocomplete and avoids a wrapper layer that would only forward `Text` props.

**Presentation conventions:**

- Each feature has a `<feature>_container.dart` (the wiring point — reads cubits from the app-shell `BlocProvider`, builds the screen) + `<feature>_screen.dart` (pure UI that reads from cubits via `BlocBuilder` / `BlocSelector`). This split keeps containers thin and screens unit-testable in isolation.
- **All cubits live in `state/` inside the feature that primarily owns them**, even when other features also read them. Following the Plastic-Avengers convention: shared cubits stay feature-scoped on disk and are made available across the tree by being provided at the app-shell level (`config/atelier_app.dart`) via `MultiBlocProvider`. Other features reach them with `context.read<X>()` or `BlocBuilder<X, _>`.
- Ownership rules:
  - `home/state/goal_categories_cubit.dart` — home is the primary mutator (manage-mode reorder/remove, plus the add-pocket flow on the empty state and `Open` slot). Detail and settings read it.
  - `detail/state/goals_cubit.dart` and `detail/state/year_goals_cubit.dart` — detail is where these are added, edited, starred, removed, expanded/collapsed. Home reads them for the pocket previews; settings writes to them on reset.
  - `home/state/manage_mode_cubit.dart` — UI-only state, used only by home. Stays feature-local in scope as well as on disk.
  - `settings/state/settings_cubit.dart` — settings owns it; the app shell reads it to drive `MaterialApp.theme` selection.
- Widgets nest by purpose subgroup (`widgets/top_bar/`, `widgets/pocket/`, `widgets/year_banner/`, `widgets/empty_state/`) so file lists stay short and intent-readable.
- `presentation/common/` holds shared UI atoms grouped by kind (`segmented/`, `text/`).
- One widget per file, every named widget gets its own file (see §7 coding rules).

**Trade-offs accepted:**

- Five top-level layers (`config`, `theme`, `domain`, `data`, `services`, `presentation`, `utils`) is more navigation than a flat layout. For an app this size we accept the cost in exchange for the structural enforcement of the dependency rules above.
- `domain/models/` for four data classes is mildly ceremonial, but keeping models in `domain/` lets us co-locate them with the contracts they appear in (model classes are part of the domain language; repository signatures use them).

## 12. Build sequence (rough)

1. Theme + typography tokens + base widgets (`Segmented` / `SegmentedOption` only — typography is plain `TextStyle` constants, no custom text widgets)
2. Domain layer: `domain/models/` (plain data classes) + `domain/repositories/` (abstract contracts)
3. Data layer: `data/drift/` (schema — database root + tables) + `data/repositories/` (Drift impls + prefs impl); no seeding (first launch is empty)
4. SharedPreferences settings repo
5. Cubits + states wired to repos, registered via `MultiBlocProvider` at app root
6. HomeScreen scaffold + TickStrip + Pocket (read-only first)
7. DetailScreen scaffold + YearBanner + GoalRow + AddBar
8. SettingsSheet
9. Manage mode (long-press, wiggle, drag-reorder, ×, cascade)
10. Tests: unit, widget, golden

The detailed breakdown lives in the implementation plan (next document).

## 13. Future considerations (deferred, noted for context)

- **Supabase sync** — implement `Supabase{Goal,GoalCategory,YearGoal}Repository` against the same interfaces; swap which impl is constructed in `main.dart` based on a build flavour or runtime flag. Cubits don't change.
- **Focused mode** — global "starred only" view across pockets.
- **Month override (debug)** — hidden setting to override `DateTime.now()` for testing chrome rollover.
- **Notifications / reminders** — opt-in, per-goal.
- **Widgets** — Android home screen widget showing today's tick + days-left.
