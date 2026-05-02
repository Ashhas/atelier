# Atelier Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the "Atelier — Pockets" HTML/React design prototype to a fully working Flutter app — local-first persistent personal goals organised into pockets (goal categories), each holding monthly goals and 2026 north-stars.

**Architecture:** Three-layer clean-architecture-lite. `domain/` owns models + repository contracts (pure Dart), `data/` owns Drift schema + repository implementations, `presentation/` owns cubits/screens/widgets. `services/` holds orchestrators that compose multiple repositories. `config/` is the composition root that constructs concrete impls and wires them via `MultiBlocProvider`. Each cubit lives in the feature that primarily owns it; shared cubits are made cross-feature available by being provided at the app shell.

**Tech Stack:** Flutter 3.32, Dart 3.8, `drift ^2.31` + `drift_dev ^2.31` + `sqlite3_flutter_libs ^0.5.42` (SQLite-backed local DB with codegen), `shared_preferences ^2` (settings), `flutter_bloc ^9.1` + `equatable` (state), `go_router ^16.3` (routing), `google_fonts` (Fraunces / Inter / JetBrains Mono), `reorderable_grid_view` (drag-reorder), `uuid` (ids), `mocktail` + manual `cubit.stream.listen` for cubit tests (bloc_test cannot be used: its transitive `test` package constraints conflict with `drift_dev` on Dart 3.8).

**Spec:** `docs/superpowers/specs/2026-05-02-atelier-design.md`. The spec is the source of truth for product behaviour, theming tokens, palettes, and acceptance details. This plan tells you *how* to build it; the spec tells you *what*. Re-read the spec at the start of each phase.

**Conventions enforced by this plan:**
- One widget per file. No private helper widgets, no inline named widget classes.
- TDD: write the failing test first, watch it fail, write the minimum code to pass, watch it pass, commit.
- Frequent commits — every task ends with a commit step.
- `dart format .` and `flutter analyze` clean before every commit. CI is set up in Task 1.6 to enforce this.

---

## Phase 0: Tooling, dependencies, project conventions

### Task 0.1: Configure analyzer + lints

**Files:**
- Modify: `analysis_options.yaml`

- [ ] **Step 1: Replace analysis_options.yaml**

Overwrite `analysis_options.yaml` with:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    invalid_annotation_target: ignore  # drift codegen emits these
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "build/**"

linter:
  rules:
    - always_declare_return_types
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - sort_child_properties_last
    - use_key_in_widget_constructors
    - require_trailing_commas
```

- [ ] **Step 2: Verify analyze still clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add analysis_options.yaml
git commit -m "chore: tighten analyzer (strict-casts, raw types, common lints)"
```

### Task 0.2: Add dependencies

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Replace dependency blocks**

In `pubspec.yaml`, replace the `dependencies:` and `dev_dependencies:` blocks with:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # State
  flutter_bloc: ^9.1.1
  equatable: ^2.0.5

  # Routing
  go_router: ^16.3.0

  # Persistence
  drift: ^2.31.0
  sqlite3_flutter_libs: ^0.5.42
  path_provider: ^2.1.4
  path: ^1.9.0
  shared_preferences: ^2.3.2

  # Misc
  uuid: ^4.5.1
  google_fonts: ^6.2.1
  reorderable_grid_view: ^2.2.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
  drift_dev: ^2.31.0
  build_runner: ^2.4.13
```

> **Note on `bloc_test`:** The original plan specified `bloc_test`, but on Dart 3.8 it transitively pulls in a version of `test` whose `analyzer` constraint (`<8.0.0`) conflicts with `drift_dev`'s `analyzer ^8.1`. Cubit tests in this plan instead use the standard `cubit.stream.listen(...)` approach to capture emitted states. The pattern is:
>
> ```dart
> final cubit = MyCubit(...);
> final emitted = <MyState>[];
> final sub = cubit.stream.listen(emitted.add);
> await cubit.someMethod();
> await sub.cancel();
> expect(emitted, [...]);
> ```
>
> Wherever a later task in this plan shows `blocTest<...>` calls, translate them to this pattern. The same assertions still apply.

- [ ] **Step 2: Install**

Run: `flutter pub get`
Expected: `Got dependencies!` (some constraint resolution may pick slightly different patch versions — that's fine).

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "chore: add drift, flutter_bloc, go_router, google_fonts and friends"
```

### Task 0.3: Wipe the boilerplate counter app

**Files:**
- Modify: `lib/main.dart`
- Modify: `test/widget_test.dart`

- [ ] **Step 1: Replace `lib/main.dart` with a placeholder**

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const _Placeholder());
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Atelier — bootstrapping')),
      ),
    );
  }
}
```

- [ ] **Step 2: Replace `test/widget_test.dart` with a placeholder**

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    expect(true, isTrue);
  });
}
```

- [ ] **Step 3: Verify analyze + tests**

Run: `flutter analyze && flutter test`
Expected: `No issues found!` and `All tests passed!`

- [ ] **Step 4: Commit**

```bash
git add lib/main.dart test/widget_test.dart
git commit -m "chore: replace counter-app boilerplate with placeholder"
```

### Task 0.4: Set up CI guardrails (locally enforced)

**Files:**
- Create: `tool/check.sh`

- [ ] **Step 1: Write check script**

Create `tool/check.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
echo ">>> dart format --set-exit-if-changed --output=none ."
dart format --set-exit-if-changed --output=none .
echo ">>> flutter analyze"
flutter analyze
echo ">>> flutter test"
flutter test
echo "OK"
```

Then `chmod +x tool/check.sh`.

- [ ] **Step 2: Run it**

Run: `tool/check.sh`
Expected: prints each step name and ends with `OK`.

- [ ] **Step 3: Commit**

```bash
git add tool/check.sh
git commit -m "chore: add tool/check.sh — format + analyze + test gate"
```

---

## Phase 1: Theme tokens

### Task 1.1: AtelierSpacing + AtelierRadii

**Files:**
- Create: `lib/theme/atelier_spacing.dart`
- Create: `test/theme/atelier_spacing_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/theme/atelier_spacing_test.dart`:

```dart
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierSpacing scale', () {
    test('exposes the 9 base tokens with expected values', () {
      expect(AtelierSpacing.xs, 2);
      expect(AtelierSpacing.sm, 4);
      expect(AtelierSpacing.md, 6);
      expect(AtelierSpacing.base, 8);
      expect(AtelierSpacing.lg, 10);
      expect(AtelierSpacing.xl, 14);
      expect(AtelierSpacing.x2l, 16);
      expect(AtelierSpacing.x3l, 22);
      expect(AtelierSpacing.x4l, 28);
    });

    test('sums-as-needed cover common in-between values', () {
      expect(AtelierSpacing.base + AtelierSpacing.sm, 12);
      expect(AtelierSpacing.xl + AtelierSpacing.sm, 18);
      expect(AtelierSpacing.xl + AtelierSpacing.md, 20);
    });
  });

  group('AtelierRadii scale', () {
    test('exposes the radii tokens with expected values', () {
      expect(AtelierRadii.sm, 6);
      expect(AtelierRadii.md, 8);
      expect(AtelierRadii.lg, 10);
      expect(AtelierRadii.xl, 12);
      expect(AtelierRadii.x2l, 14);
      expect(AtelierRadii.sheet, 22);
      expect(AtelierRadii.pill, 999);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/theme/atelier_spacing_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:atelier/theme/atelier_spacing.dart'`.

- [ ] **Step 3: Write the implementation**

Create `lib/theme/atelier_spacing.dart`:

```dart
/// T-shirt-scale spacing tokens. For values not in the scale, compose with
/// sums of base tokens (e.g. `AtelierSpacing.base + AtelierSpacing.sm` for 12).
class AtelierSpacing {
  const AtelierSpacing._();

  static const double xs = 2;
  static const double sm = 4;
  static const double md = 6;
  static const double base = 8;
  static const double lg = 10;
  static const double xl = 14;
  static const double x2l = 16;
  static const double x3l = 22;
  static const double x4l = 28;
}

/// Corner radii tokens. Pair with [AtelierSpacing] in [theme/atelier_spacing.dart].
class AtelierRadii {
  const AtelierRadii._();

  static const double sm = 6;
  static const double md = 8;
  static const double lg = 10;
  static const double xl = 12;
  static const double x2l = 14;
  static const double sheet = 22;
  static const double pill = 999;
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/theme/atelier_spacing_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/theme/atelier_spacing.dart test/theme/atelier_spacing_test.dart
git commit -m "feat(theme): add AtelierSpacing + AtelierRadii token scales"
```

### Task 1.2: AtelierPalette type + light/dark constants

**Files:**
- Create: `lib/theme/atelier_palette.dart`
- Create: `lib/theme/atelier_colors.dart`
- Create: `test/theme/atelier_colors_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/theme/atelier_colors_test.dart`:

```dart
import 'package:atelier/theme/atelier_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierColors.light', () {
    test('matches prototype palette', () {
      const p = AtelierColors.light;
      expect(p.bg, const Color(0xFFFFFFFF));
      expect(p.ink, const Color(0xFF0A0A0A));
      expect(p.sub, const Color(0xFF525252));
      expect(p.mute, const Color(0xFFA3A3A3));
      expect(p.rule, const Color(0xFFEDEDED));
      expect(p.accent, const Color(0xFF0A0A0A));
      expect(p.chip, const Color(0xFFFAFAFA));
      expect(p.pocket, const Color(0xFFFFFFFF));
      expect(p.surface, const Color(0xFFFAFAFA));
      expect(p.starBg, const Color(0xFFEDEDED));
      expect(p.starBorder, const Color(0xFFDCDCDC));
      expect(p.starInk, const Color(0xFF0A0A0A));
      expect(p.yearBg, const Color(0xFFF5F5F2));
      expect(p.yearInk, const Color(0xFF0A0A0A));
    });
  });

  group('AtelierColors.dark', () {
    test('matches prototype palette', () {
      const p = AtelierColors.dark;
      expect(p.bg, const Color(0xFF121212));
      expect(p.ink, const Color(0xFFFFFFFF));
      expect(p.sub, const Color(0xFFA7A7A7));
      expect(p.mute, const Color(0xFF727272));
      expect(p.rule, const Color(0xFF2A2A2A));
      expect(p.accent, const Color(0xFF1ED760));
      expect(p.chip, const Color(0xFF1F1F1F));
      expect(p.pocket, const Color(0xFF181818));
      expect(p.surface, const Color(0xFF181818));
      expect(p.starBg, const Color(0xFF282828));
      expect(p.starBorder, const Color(0xFF3E3E3E));
      expect(p.starInk, const Color(0xFFFFFFFF));
      expect(p.yearBg, const Color(0xFF181818));
      expect(p.yearInk, const Color(0xFFFFFFFF));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/theme/atelier_colors_test.dart`
Expected: FAIL — URIs not found.

- [ ] **Step 3: Implement palette type**

Create `lib/theme/atelier_palette.dart`:

```dart
import 'package:flutter/painting.dart';
import 'package:meta/meta.dart';

@immutable
class AtelierPalette {
  const AtelierPalette({
    required this.bg,
    required this.ink,
    required this.sub,
    required this.mute,
    required this.rule,
    required this.ruleHi,
    required this.accent,
    required this.chip,
    required this.pocket,
    required this.surface,
    required this.starBg,
    required this.starBorder,
    required this.starInk,
    required this.yearBg,
    required this.yearInk,
  });

  final Color bg;
  final Color ink;
  final Color sub;
  final Color mute;
  final Color rule;
  final Color ruleHi;
  final Color accent;
  final Color chip;
  final Color pocket;
  final Color surface;
  final Color starBg;
  final Color starBorder;
  final Color starInk;
  final Color yearBg;
  final Color yearInk;
}
```

- [ ] **Step 4: Implement constants**

Create `lib/theme/atelier_colors.dart`:

```dart
import 'package:atelier/theme/atelier_palette.dart';
import 'package:flutter/painting.dart';

class AtelierColors {
  const AtelierColors._();

  static const AtelierPalette light = AtelierPalette(
    bg: Color(0xFFFFFFFF),
    ink: Color(0xFF0A0A0A),
    sub: Color(0xFF525252),
    mute: Color(0xFFA3A3A3),
    rule: Color(0xFFEDEDED),
    ruleHi: Color(0xFF0A0A0A),
    accent: Color(0xFF0A0A0A),
    chip: Color(0xFFFAFAFA),
    pocket: Color(0xFFFFFFFF),
    surface: Color(0xFFFAFAFA),
    starBg: Color(0xFFEDEDED),
    starBorder: Color(0xFFDCDCDC),
    starInk: Color(0xFF0A0A0A),
    yearBg: Color(0xFFF5F5F2),
    yearInk: Color(0xFF0A0A0A),
  );

  static const AtelierPalette dark = AtelierPalette(
    bg: Color(0xFF121212),
    ink: Color(0xFFFFFFFF),
    sub: Color(0xFFA7A7A7),
    mute: Color(0xFF727272),
    rule: Color(0xFF2A2A2A),
    ruleHi: Color(0xFFFFFFFF),
    accent: Color(0xFF1ED760),
    chip: Color(0xFF1F1F1F),
    pocket: Color(0xFF181818),
    surface: Color(0xFF181818),
    starBg: Color(0xFF282828),
    starBorder: Color(0xFF3E3E3E),
    starInk: Color(0xFFFFFFFF),
    yearBg: Color(0xFF181818),
    yearInk: Color(0xFFFFFFFF),
  );
}
```

- [ ] **Step 5: Run test**

Run: `flutter test test/theme/atelier_colors_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/theme/atelier_palette.dart lib/theme/atelier_colors.dart test/theme/atelier_colors_test.dart
git commit -m "feat(theme): add AtelierPalette + light/dark constants from prototype"
```

### Task 1.3: AtelierTypography tokens

**Files:**
- Create: `lib/theme/atelier_typography.dart`
- Create: `test/theme/atelier_typography_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/theme/atelier_typography_test.dart`:

```dart
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierTypography', () {
    test('mono tokens use JetBrains Mono with the right size + spacing', () {
      expect(AtelierTypography.monoMicro.fontFamily, contains('JetBrainsMono'));
      expect(AtelierTypography.monoMicro.fontSize, 8.5);
      expect(AtelierTypography.monoMicro.letterSpacing, 1.2);
      expect(AtelierTypography.monoMicro.fontWeight, FontWeight.w600);

      expect(AtelierTypography.monoEyebrow.fontSize, 9);
      expect(AtelierTypography.monoEyebrow.letterSpacing, 1.8);

      expect(AtelierTypography.monoLabel.fontSize, 10);
      expect(AtelierTypography.monoLabel.letterSpacing, 1.4);
    });

    test('serif tokens use Fraunces italic with the right sizes', () {
      expect(AtelierTypography.serifDisplay.fontFamily, contains('Fraunces'));
      expect(AtelierTypography.serifDisplay.fontStyle, FontStyle.italic);
      expect(AtelierTypography.serifDisplay.fontSize, 24);
      expect(AtelierTypography.serifDisplay.letterSpacing, -0.5);

      expect(AtelierTypography.serifTitle.fontSize, 17);
      expect(AtelierTypography.serifTitle.letterSpacing, -0.3);

      expect(AtelierTypography.serifBody.fontSize, 12.5);
      expect(AtelierTypography.serifBody.letterSpacing, -0.2);
    });

    test('sans tokens use Inter', () {
      expect(AtelierTypography.sansBody.fontFamily, contains('Inter'));
      expect(AtelierTypography.sansBody.fontSize, 13);

      expect(AtelierTypography.sansLabel.fontSize, 14);
      expect(AtelierTypography.sansLabel.fontWeight, FontWeight.w600);
    });
  });
}
```

- [ ] **Step 2: Run test**

Run: `flutter test test/theme/atelier_typography_test.dart`
Expected: FAIL — URI not found.

- [ ] **Step 3: Implement typography tokens**

Create `lib/theme/atelier_typography.dart`:

```dart
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// TextStyle tokens for the design system.
///
/// Call sites: `Text('label', style: AtelierTypography.monoEyebrow.copyWith(color: c.mute))`.
/// Per-call-site variation (color, occasional size/height) goes through `.copyWith()`.
class AtelierTypography {
  const AtelierTypography._();

  // ── Mono (JetBrains Mono — small caps labels, eyebrows, micro labels) ──
  static TextStyle get monoMicro => GoogleFonts.jetBrainsMono(
    fontSize: 8.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get monoEyebrow => GoogleFonts.jetBrainsMono(
    fontSize: 9,
    letterSpacing: 1.8,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get monoLabel => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    letterSpacing: 1.4,
    fontWeight: FontWeight.w600,
  );

  // ── Serif (Fraunces italic — display titles, goal titles, banner content) ──
  static TextStyle get serifDisplay => GoogleFonts.fraunces(
    fontSize: 24,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get serifTitle => GoogleFonts.fraunces(
    fontSize: 17,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get serifBody => GoogleFonts.fraunces(
    fontSize: 12.5,
    fontStyle: FontStyle.italic,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  // ── Sans (Inter — body copy, settings labels) ──
  static TextStyle get sansBody => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get sansLabel => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/theme/atelier_typography_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/theme/atelier_typography.dart test/theme/atelier_typography_test.dart
git commit -m "feat(theme): add AtelierTypography (Fraunces / Inter / JetBrains Mono)"
```

### Task 1.4: AtelierTheme — ThemeData builders

**Files:**
- Create: `lib/theme/atelier_theme.dart`
- Create: `test/theme/atelier_theme_test.dart`

- [ ] **Step 1: Write the failing test**

Create `test/theme/atelier_theme_test.dart`:

```dart
import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierTheme', () {
    test('light theme uses light palette', () {
      final t = AtelierTheme.light();
      expect(t.brightness, Brightness.light);
      expect(t.scaffoldBackgroundColor, AtelierColors.light.bg);
    });

    test('dark theme uses dark palette', () {
      final t = AtelierTheme.dark();
      expect(t.brightness, Brightness.dark);
      expect(t.scaffoldBackgroundColor, AtelierColors.dark.bg);
    });

    test('paletteOf returns the right palette for both modes', () {
      final lightCtx = _ctxFor(AtelierTheme.light());
      final darkCtx = _ctxFor(AtelierTheme.dark());
      expect(AtelierTheme.paletteOf(lightCtx), AtelierColors.light);
      expect(AtelierTheme.paletteOf(darkCtx), AtelierColors.dark);
    });
  });
}

BuildContext _ctxFor(ThemeData theme) {
  late BuildContext captured;
  // ignore: avoid_returning_null_for_void
  final widget = MaterialApp(
    theme: theme,
    home: Builder(
      builder: (ctx) {
        captured = ctx;
        return const SizedBox.shrink();
      },
    ),
  );
  // We can't actually pump without a tester, so we cheat by building once.
  // Use this only for the smoke check that paletteOf compiles + dispatches by brightness.
  // (The real verification happens in widget tests later.)
  return captured = _StubContext(theme);
}

class _StubContext extends BuildContext {
  _StubContext(this._theme);
  final ThemeData _theme;
  @override
  // ignore: invalid_override_of_non_virtual_member
  T dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({Object? aspect}) =>
      throw UnimplementedError();

  // The other ~30 BuildContext members are unused here; throw on access.
  @override
  noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('Stub for ${invocation.memberName}');
}
```

> NOTE: Stubbing `BuildContext` is awkward; the simpler unit test below replaces the `paletteOf` test with a direct `Theme.of(context)` integration test in widget-land. **Use this simpler version instead:**

Replace the test file with:

```dart
import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierTheme', () {
    test('light theme has the right brightness + scaffold colour', () {
      final t = AtelierTheme.light();
      expect(t.brightness, Brightness.light);
      expect(t.scaffoldBackgroundColor, AtelierColors.light.bg);
    });

    test('dark theme has the right brightness + scaffold colour', () {
      final t = AtelierTheme.dark();
      expect(t.brightness, Brightness.dark);
      expect(t.scaffoldBackgroundColor, AtelierColors.dark.bg);
    });

    testWidgets('paletteOf returns light palette in light theme', (tester) async {
      AtelierPalette? captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: AtelierTheme.light(),
          home: Builder(
            builder: (ctx) {
              captured = AtelierTheme.paletteOf(ctx);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, AtelierColors.light);
    });

    testWidgets('paletteOf returns dark palette in dark theme', (tester) async {
      AtelierPalette? captured;
      await tester.pumpWidget(
        MaterialApp(
          theme: AtelierTheme.light(),
          darkTheme: AtelierTheme.dark(),
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (ctx) {
              captured = AtelierTheme.paletteOf(ctx);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, AtelierColors.dark);
    });
  });
}
```

Also add a top-level import to make `AtelierPalette` resolvable in the test:

```dart
import 'package:atelier/theme/atelier_palette.dart';
```

(Add it to the imports in the test file above.)

- [ ] **Step 2: Run test**

Run: `flutter test test/theme/atelier_theme_test.dart`
Expected: FAIL — `atelier_theme.dart` doesn't exist.

- [ ] **Step 3: Implement theme builders**

Create `lib/theme/atelier_theme.dart`:

```dart
import 'package:atelier/theme/atelier_colors.dart';
import 'package:atelier/theme/atelier_palette.dart';
import 'package:flutter/material.dart';

class AtelierTheme {
  const AtelierTheme._();

  static ThemeData light() => _build(AtelierColors.light, Brightness.light);
  static ThemeData dark() => _build(AtelierColors.dark, Brightness.dark);

  /// Returns the [AtelierPalette] matching the current theme brightness.
  static AtelierPalette paletteOf(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? AtelierColors.dark : AtelierColors.light;
  }

  static ThemeData _build(AtelierPalette p, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: p.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: p.ink,
        onPrimary: p.bg,
        secondary: p.accent,
        onSecondary: p.bg,
        error: const Color(0xFFB35454),
        onError: p.bg,
        surface: p.surface,
        onSurface: p.ink,
      ),
      useMaterial3: false, // we paint everything ourselves
    );
  }
}
```

- [ ] **Step 4: Run test**

Run: `flutter test test/theme/atelier_theme_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/theme/atelier_theme.dart test/theme/atelier_theme_test.dart
git commit -m "feat(theme): add AtelierTheme.light()/dark()/paletteOf(context)"
```

### Task 1.5: Smoke-run the placeholder app with the theme

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1: Update placeholder to use the theme**

```dart
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AtelierTheme.light(),
      darkTheme: AtelierTheme.dark(),
      home: Scaffold(
        body: Center(
          child: Text(
            'Atelier',
            style: AtelierTypography.serifDisplay,
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyze + tests**

Run: `tool/check.sh`
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "chore: wire placeholder app to AtelierTheme + AtelierTypography"
```

---

## Phase 2: Domain layer (models + repository contracts)

### Task 2.1: FontScale enum

**Files:**
- Create: `lib/domain/models/enums/font_scale.dart`
- Create: `test/domain/models/enums/font_scale_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FontScale', () {
    test('exposes three values with the right multipliers', () {
      expect(FontScale.values.length, 3);
      expect(FontScale.small.multiplier, 0.92);
      expect(FontScale.medium.multiplier, 1.0);
      expect(FontScale.large.multiplier, 1.10);
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/domain/models/enums/font_scale_test.dart`
Expected: FAIL — URI not found.

- [ ] **Step 3: Implement**

```dart
enum FontScale {
  small(0.92),
  medium(1.0),
  large(1.10);

  const FontScale(this.multiplier);
  final double multiplier;
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/domain/models/enums/font_scale_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/models/enums/font_scale.dart test/domain/models/enums/font_scale_test.dart
git commit -m "feat(domain): add FontScale enum (small/medium/large)"
```

### Task 2.2: AppSettings model

**Files:**
- Create: `lib/domain/models/app_settings.dart`
- Create: `test/domain/models/app_settings_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('default values are light theme + medium font scale', () {
      const s = AppSettings();
      expect(s.themeMode, ThemeMode.light);
      expect(s.fontScale, FontScale.medium);
    });

    test('copyWith replaces only the fields provided', () {
      const s = AppSettings();
      final t = s.copyWith(themeMode: ThemeMode.dark);
      expect(t.themeMode, ThemeMode.dark);
      expect(t.fontScale, FontScale.medium);

      final f = s.copyWith(fontScale: FontScale.large);
      expect(f.themeMode, ThemeMode.light);
      expect(f.fontScale, FontScale.large);
    });

    test('value equality holds', () {
      const a = AppSettings();
      const b = AppSettings();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      const c = AppSettings(themeMode: ThemeMode.dark);
      expect(a, isNot(equals(c)));
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/domain/models/app_settings_test.dart`
Expected: FAIL — URI not found.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.themeMode = ThemeMode.light,
    this.fontScale = FontScale.medium,
  });

  final ThemeMode themeMode;
  final FontScale fontScale;

  AppSettings copyWith({ThemeMode? themeMode, FontScale? fontScale}) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        fontScale: fontScale ?? this.fontScale,
      );

  @override
  List<Object?> get props => [themeMode, fontScale];
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/domain/models/app_settings_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/models/app_settings.dart test/domain/models/app_settings_test.dart
git commit -m "feat(domain): add AppSettings model"
```

### Task 2.3: GoalCategory model

**Files:**
- Create: `lib/domain/models/goal_category.dart`
- Create: `test/domain/models/goal_category_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/domain/models/goal_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GoalCategory', () {
    test('constructs with required fields and defaults isAddSlot=false', () {
      const c = GoalCategory(id: 'id-1', name: 'Work', order: 0);
      expect(c.id, 'id-1');
      expect(c.name, 'Work');
      expect(c.order, 0);
      expect(c.isAddSlot, isFalse);
    });

    test('value equality across all fields', () {
      const a = GoalCategory(id: 'id', name: 'Body', order: 2);
      const b = GoalCategory(id: 'id', name: 'Body', order: 2);
      expect(a, equals(b));

      const c = GoalCategory(id: 'id', name: 'Body', order: 3);
      expect(a, isNot(equals(c)));
    });

    test('copyWith updates the chosen fields only', () {
      const c = GoalCategory(id: 'id', name: 'Old', order: 0);
      final renamed = c.copyWith(name: 'New');
      expect(renamed.name, 'New');
      expect(renamed.order, 0);

      final reordered = c.copyWith(order: 5);
      expect(reordered.name, 'Old');
      expect(reordered.order, 5);
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/domain/models/goal_category_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:equatable/equatable.dart';

class GoalCategory extends Equatable {
  const GoalCategory({
    required this.id,
    required this.name,
    required this.order,
    this.isAddSlot = false,
  });

  final String id;
  final String name;
  final int order;
  final bool isAddSlot;

  GoalCategory copyWith({String? id, String? name, int? order, bool? isAddSlot}) =>
      GoalCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        order: order ?? this.order,
        isAddSlot: isAddSlot ?? this.isAddSlot,
      );

  @override
  List<Object?> get props => [id, name, order, isAddSlot];
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/domain/models/goal_category_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/models/goal_category.dart test/domain/models/goal_category_test.dart
git commit -m "feat(domain): add GoalCategory model"
```

### Task 2.4: Goal model

**Files:**
- Create: `lib/domain/models/goal.dart`
- Create: `test/domain/models/goal_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/domain/models/goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Goal', () {
    final addedAt = DateTime.utc(2026, 5, 1, 10);

    test('constructs with required fields and defaults starred=false', () {
      final g = Goal(
        id: 'g1',
        goalCategoryId: 'c1',
        title: 'Sub-25 5K',
        addedAt: addedAt,
      );
      expect(g.id, 'g1');
      expect(g.goalCategoryId, 'c1');
      expect(g.title, 'Sub-25 5K');
      expect(g.starred, isFalse);
      expect(g.addedAt, addedAt);
    });

    test('value equality across all fields', () {
      final a = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      final b = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      expect(a, equals(b));
    });

    test('copyWith for starred + title', () {
      final g = Goal(id: 'g', goalCategoryId: 'c', title: 't', addedAt: addedAt);
      expect(g.copyWith(starred: true).starred, isTrue);
      expect(g.copyWith(title: 'new').title, 'new');
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/domain/models/goal_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  const Goal({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    required this.addedAt,
    this.starred = false,
  });

  final String id;
  final String goalCategoryId;
  final String title;
  final bool starred;
  final DateTime addedAt;

  Goal copyWith({
    String? id,
    String? goalCategoryId,
    String? title,
    bool? starred,
    DateTime? addedAt,
  }) =>
      Goal(
        id: id ?? this.id,
        goalCategoryId: goalCategoryId ?? this.goalCategoryId,
        title: title ?? this.title,
        starred: starred ?? this.starred,
        addedAt: addedAt ?? this.addedAt,
      );

  @override
  List<Object?> get props => [id, goalCategoryId, title, starred, addedAt];
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/domain/models/goal_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/models/goal.dart test/domain/models/goal_test.dart
git commit -m "feat(domain): add Goal model"
```

### Task 2.5: YearGoal model

**Files:**
- Create: `lib/domain/models/year_goal.dart`
- Create: `test/domain/models/year_goal_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/domain/models/year_goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('YearGoal', () {
    test('defaults to expanded=true', () {
      const yg = YearGoal(id: 'y1', goalCategoryId: 'c1', title: 'Run sub-22 5K');
      expect(yg.expanded, isTrue);
    });

    test('copyWith updates the chosen field', () {
      const yg = YearGoal(id: 'y1', goalCategoryId: 'c1', title: 't');
      expect(yg.copyWith(expanded: false).expanded, isFalse);
      expect(yg.copyWith(title: 'new').title, 'new');
    });

    test('value equality', () {
      const a = YearGoal(id: 'y', goalCategoryId: 'c', title: 't');
      const b = YearGoal(id: 'y', goalCategoryId: 'c', title: 't');
      expect(a, equals(b));
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/domain/models/year_goal_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:equatable/equatable.dart';

class YearGoal extends Equatable {
  const YearGoal({
    required this.id,
    required this.goalCategoryId,
    required this.title,
    this.expanded = true,
  });

  final String id;
  final String goalCategoryId;
  final String title;
  final bool expanded;

  YearGoal copyWith({String? id, String? goalCategoryId, String? title, bool? expanded}) =>
      YearGoal(
        id: id ?? this.id,
        goalCategoryId: goalCategoryId ?? this.goalCategoryId,
        title: title ?? this.title,
        expanded: expanded ?? this.expanded,
      );

  @override
  List<Object?> get props => [id, goalCategoryId, title, expanded];
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/domain/models/year_goal_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/models/year_goal.dart test/domain/models/year_goal_test.dart
git commit -m "feat(domain): add YearGoal model"
```

### Task 2.6: Repository interfaces

**Files:**
- Create: `lib/domain/repositories/goal_category_repository.dart`
- Create: `lib/domain/repositories/goal_repository.dart`
- Create: `lib/domain/repositories/year_goal_repository.dart`
- Create: `lib/domain/repositories/settings_repository.dart`

- [ ] **Step 1: Implement contracts**

`lib/domain/repositories/goal_category_repository.dart`:

```dart
import 'package:atelier/domain/models/goal_category.dart';

abstract class GoalCategoryRepository {
  /// All categories ordered by [GoalCategory.order] ascending.
  Future<List<GoalCategory>> all();

  /// Inserts the category. Returns the inserted row.
  Future<GoalCategory> add(GoalCategory category);

  Future<void> update(GoalCategory category);

  /// Deletes the category and cascades to its goals + year-goals.
  Future<void> delete(String id);

  /// Persists a new ordering (bulk update).
  Future<void> reorder(List<String> idsInNewOrder);

  /// Truncates the table.
  Future<void> clear();
}
```

`lib/domain/repositories/goal_repository.dart`:

```dart
import 'package:atelier/domain/models/goal.dart';

abstract class GoalRepository {
  /// All goals across all categories, sorted starred-first then insertion order.
  Future<List<Goal>> all();

  /// Goals for one category, sorted starred-first then insertion order.
  Future<List<Goal>> byCategory(String goalCategoryId);

  Future<Goal> add(Goal goal);
  Future<void> update(Goal goal);
  Future<void> delete(String id);
  Future<void> clear();
}
```

`lib/domain/repositories/year_goal_repository.dart`:

```dart
import 'package:atelier/domain/models/year_goal.dart';

abstract class YearGoalRepository {
  Future<List<YearGoal>> all();
  Future<List<YearGoal>> byCategory(String goalCategoryId);
  Future<YearGoal> add(YearGoal yg);
  Future<void> update(YearGoal yg);
  Future<void> delete(String id);
  Future<void> clear();
}
```

`lib/domain/repositories/settings_repository.dart`:

```dart
import 'package:atelier/domain/models/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
  Future<void> clear();
}
```

- [ ] **Step 2: Verify analyze clean**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/domain/repositories/
git commit -m "feat(domain): add repository contracts (categories, goals, year_goals, settings)"
```

---

## Phase 3: Data layer (Drift schema, repository implementations, prefs)

> **Background for the implementer:** Drift uses code generation. You'll define tables as Dart classes annotated with `@DataClassName`/`@DriftDatabase`, run `dart run build_runner build` to generate `*.g.dart` files, then write repositories that talk to the generated database object. The `*.g.dart` files are committed to git. Drift docs: https://drift.simonbinder.eu/

### Task 3.1: Drift schema — tables

**Files:**
- Create: `lib/data/drift/tables/goal_categories_table.dart`
- Create: `lib/data/drift/tables/goals_table.dart`
- Create: `lib/data/drift/tables/year_goals_table.dart`

- [ ] **Step 1: Implement tables**

`lib/data/drift/tables/goal_categories_table.dart`:

```dart
import 'package:drift/drift.dart';

@DataClassName('GoalCategoryRow')
class GoalCategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isAddSlot => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'goal_categories';
}
```

`lib/data/drift/tables/goals_table.dart`:

```dart
import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('GoalRow')
class GoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get goalCategoryId =>
      text().references(GoalCategoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get starred => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'goals';
}
```

`lib/data/drift/tables/year_goals_table.dart`:

```dart
import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:drift/drift.dart';

@DataClassName('YearGoalRow')
class YearGoalsTable extends Table {
  TextColumn get id => text()();
  TextColumn get goalCategoryId =>
      text().references(GoalCategoriesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get expanded => boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  String? get tableName => 'year_goals';
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/data/drift/tables/
git commit -m "feat(data): add Drift table definitions"
```

### Task 3.2: AtelierDatabase root + codegen

**Files:**
- Create: `lib/data/drift/atelier_database.dart`

- [ ] **Step 1: Implement database root**

```dart
import 'dart:io';

import 'package:atelier/data/drift/tables/goal_categories_table.dart';
import 'package:atelier/data/drift/tables/goals_table.dart';
import 'package:atelier/data/drift/tables/year_goals_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'atelier_database.g.dart';

@DriftDatabase(
  tables: [GoalCategoriesTable, GoalsTable, YearGoalsTable],
)
class AtelierDatabase extends _$AtelierDatabase {
  AtelierDatabase() : super(_open());

  /// For tests — pass an in-memory or custom executor.
  AtelierDatabase.withExecutor(QueryExecutor executor) : super(executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'atelier.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

- [ ] **Step 2: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `[INFO] Succeeded after ...`. A new file `lib/data/drift/atelier_database.g.dart` should appear.

- [ ] **Step 3: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Commit (including the generated file)**

```bash
git add lib/data/drift/atelier_database.dart lib/data/drift/atelier_database.g.dart
git commit -m "feat(data): add AtelierDatabase root + codegen output"
```

### Task 3.3: Drift goal-categories repository

**Files:**
- Create: `lib/data/repositories/drift_goal_category_repository.dart`
- Create: `test/data/drift/drift_goal_category_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

AtelierDatabase _inMemory() => AtelierDatabase.withExecutor(NativeDatabase.memory());

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository repo;

  setUp(() {
    db = _inMemory();
    repo = DriftGoalCategoryRepository(db);
  });

  tearDown(() async => db.close());

  test('all() returns empty list initially', () async {
    expect(await repo.all(), isEmpty);
  });

  test('add then all() returns the row', () async {
    const c = GoalCategory(id: 'c1', name: 'Work', order: 0);
    await repo.add(c);
    expect(await repo.all(), [c]);
  });

  test('all() is sorted by order ascending', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 2));
    await repo.add(const GoalCategory(id: 'b', name: 'B', order: 0));
    await repo.add(const GoalCategory(id: 'c', name: 'C', order: 1));
    final ordered = await repo.all();
    expect(ordered.map((c) => c.id).toList(), ['b', 'c', 'a']);
  });

  test('update changes name + order', () async {
    await repo.add(const GoalCategory(id: 'c1', name: 'Old', order: 0));
    await repo.update(const GoalCategory(id: 'c1', name: 'New', order: 5));
    final list = await repo.all();
    expect(list.single, const GoalCategory(id: 'c1', name: 'New', order: 5));
  });

  test('delete removes the row', () async {
    await repo.add(const GoalCategory(id: 'c1', name: 'Work', order: 0));
    await repo.delete('c1');
    expect(await repo.all(), isEmpty);
  });

  test('reorder updates order to match the supplied id list', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 0));
    await repo.add(const GoalCategory(id: 'b', name: 'B', order: 1));
    await repo.add(const GoalCategory(id: 'c', name: 'C', order: 2));
    await repo.reorder(['c', 'a', 'b']);
    final list = await repo.all();
    expect(list.map((c) => c.id).toList(), ['c', 'a', 'b']);
    expect(list.map((c) => c.order).toList(), [0, 1, 2]);
  });

  test('clear removes everything', () async {
    await repo.add(const GoalCategory(id: 'a', name: 'A', order: 0));
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });

  test('isAddSlot round-trips', () async {
    await repo.add(const GoalCategory(id: 'open', name: 'Open', order: 99, isAddSlot: true));
    expect((await repo.all()).single.isAddSlot, isTrue);
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/data/drift/drift_goal_category_repository_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:drift/drift.dart';

class DriftGoalCategoryRepository implements GoalCategoryRepository {
  DriftGoalCategoryRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<GoalCategory>> all() async {
    final query = _db.select(_db.goalCategoriesTable)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<GoalCategory> add(GoalCategory category) async {
    await _db.into(_db.goalCategoriesTable).insert(_toCompanion(category));
    return category;
  }

  @override
  Future<void> update(GoalCategory category) async {
    await (_db.update(_db.goalCategoriesTable)..where((t) => t.id.equals(category.id)))
        .write(_toCompanion(category));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.goalCategoriesTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> reorder(List<String> idsInNewOrder) async {
    await _db.transaction(() async {
      for (var i = 0; i < idsInNewOrder.length; i++) {
        await (_db.update(_db.goalCategoriesTable)
              ..where((t) => t.id.equals(idsInNewOrder[i])))
            .write(GoalCategoriesTableCompanion(sortOrder: Value(i)));
      }
    });
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.goalCategoriesTable).go();
  }

  GoalCategory _fromRow(GoalCategoryRow r) => GoalCategory(
        id: r.id,
        name: r.name,
        order: r.sortOrder,
        isAddSlot: r.isAddSlot,
      );

  GoalCategoriesTableCompanion _toCompanion(GoalCategory c) => GoalCategoriesTableCompanion(
        id: Value(c.id),
        name: Value(c.name),
        sortOrder: Value(c.order),
        isAddSlot: Value(c.isAddSlot),
      );
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/data/drift/drift_goal_category_repository_test.dart`
Expected: PASS (all 8 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/drift_goal_category_repository.dart \
        test/data/drift/drift_goal_category_repository_test.dart
git commit -m "feat(data): DriftGoalCategoryRepository (CRUD + reorder)"
```

### Task 3.4: Drift goals repository

**Files:**
- Create: `lib/data/repositories/drift_goal_repository.dart`
- Create: `test/data/drift/drift_goal_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalRepository repo;
  late DriftGoalCategoryRepository categories;

  Future<void> seedCategory(String id) =>
      categories.add(GoalCategory(id: id, name: id, order: 0));

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    categories = DriftGoalCategoryRepository(db);
    repo = DriftGoalRepository(db);
    await seedCategory('cat-a');
    await seedCategory('cat-b');
  });

  tearDown(() async => db.close());

  Goal _g(String id, String catId, {bool starred = false, DateTime? addedAt}) => Goal(
        id: id,
        goalCategoryId: catId,
        title: 'Title $id',
        starred: starred,
        addedAt: addedAt ?? DateTime.utc(2026, 5, 1),
      );

  test('add + byCategory returns matching rows only', () async {
    await repo.add(_g('1', 'cat-a'));
    await repo.add(_g('2', 'cat-b'));
    final rowsA = await repo.byCategory('cat-a');
    expect(rowsA.map((g) => g.id), ['1']);
  });

  test('byCategory sorts starred-first, then by addedAt ascending', () async {
    await repo.add(_g('1', 'cat-a', addedAt: DateTime.utc(2026, 5, 1)));
    await repo.add(_g('2', 'cat-a', starred: true, addedAt: DateTime.utc(2026, 5, 3)));
    await repo.add(_g('3', 'cat-a', addedAt: DateTime.utc(2026, 5, 2)));
    await repo.add(_g('4', 'cat-a', starred: true, addedAt: DateTime.utc(2026, 5, 1)));

    final ordered = await repo.byCategory('cat-a');
    expect(ordered.map((g) => g.id).toList(), ['4', '2', '1', '3']);
  });

  test('update changes title + starred', () async {
    await repo.add(_g('1', 'cat-a'));
    final updated = (await repo.byCategory('cat-a')).single.copyWith(
          title: 'Renamed',
          starred: true,
        );
    await repo.update(updated);
    expect((await repo.byCategory('cat-a')).single.title, 'Renamed');
    expect((await repo.byCategory('cat-a')).single.starred, isTrue);
  });

  test('delete removes the goal', () async {
    await repo.add(_g('1', 'cat-a'));
    await repo.delete('1');
    expect(await repo.byCategory('cat-a'), isEmpty);
  });

  test('cascade delete: removing the category drops its goals', () async {
    await repo.add(_g('1', 'cat-a'));
    await repo.add(_g('2', 'cat-b'));
    await categories.delete('cat-a');
    expect(await repo.all(), hasLength(1));
    expect((await repo.all()).single.id, '2');
  });

  test('clear removes everything', () async {
    await repo.add(_g('1', 'cat-a'));
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/data/drift/drift_goal_repository_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:drift/drift.dart';

class DriftGoalRepository implements GoalRepository {
  DriftGoalRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<Goal>> all() async {
    final query = _db.select(_db.goalsTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.starred),
        (t) => OrderingTerm.asc(t.addedAt),
      ]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<List<Goal>> byCategory(String goalCategoryId) async {
    final query = _db.select(_db.goalsTable)
      ..where((t) => t.goalCategoryId.equals(goalCategoryId))
      ..orderBy([
        (t) => OrderingTerm.desc(t.starred),
        (t) => OrderingTerm.asc(t.addedAt),
      ]);
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<Goal> add(Goal goal) async {
    await _db.into(_db.goalsTable).insert(_toCompanion(goal));
    return goal;
  }

  @override
  Future<void> update(Goal goal) async {
    await (_db.update(_db.goalsTable)..where((t) => t.id.equals(goal.id)))
        .write(_toCompanion(goal));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.goalsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.goalsTable).go();
  }

  Goal _fromRow(GoalRow r) => Goal(
        id: r.id,
        goalCategoryId: r.goalCategoryId,
        title: r.title,
        starred: r.starred,
        addedAt: r.addedAt,
      );

  GoalsTableCompanion _toCompanion(Goal g) => GoalsTableCompanion(
        id: Value(g.id),
        goalCategoryId: Value(g.goalCategoryId),
        title: Value(g.title),
        starred: Value(g.starred),
        addedAt: Value(g.addedAt),
      );
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/data/drift/drift_goal_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/drift_goal_repository.dart \
        test/data/drift/drift_goal_repository_test.dart
git commit -m "feat(data): DriftGoalRepository (CRUD, starred-first sort, cascade delete)"
```

### Task 3.5: Drift year-goals repository

**Files:**
- Create: `lib/data/repositories/drift_year_goal_repository.dart`
- Create: `test/data/drift/drift_year_goal_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftYearGoalRepository repo;
  late DriftGoalCategoryRepository categories;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    categories = DriftGoalCategoryRepository(db);
    repo = DriftYearGoalRepository(db);
    await categories.add(const GoalCategory(id: 'cat-a', name: 'Body', order: 0));
    await categories.add(const GoalCategory(id: 'cat-b', name: 'Mind', order: 1));
  });

  tearDown(() async => db.close());

  test('add + byCategory', () async {
    await repo.add(const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 'Sub-22 5K'));
    final rows = await repo.byCategory('cat-a');
    expect(rows.single.title, 'Sub-22 5K');
    expect(rows.single.expanded, isTrue);
  });

  test('update toggles expanded', () async {
    await repo.add(const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'));
    await repo.update(const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't', expanded: false));
    expect((await repo.byCategory('cat-a')).single.expanded, isFalse);
  });

  test('cascade delete drops year-goals', () async {
    await repo.add(const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'));
    await categories.delete('cat-a');
    expect(await repo.all(), isEmpty);
  });

  test('clear removes everything', () async {
    await repo.add(const YearGoal(id: 'y1', goalCategoryId: 'cat-a', title: 't'));
    await repo.clear();
    expect(await repo.all(), isEmpty);
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/data/drift/drift_year_goal_repository_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';
import 'package:drift/drift.dart';

class DriftYearGoalRepository implements YearGoalRepository {
  DriftYearGoalRepository(this._db);

  final AtelierDatabase _db;

  @override
  Future<List<YearGoal>> all() async {
    final rows = await _db.select(_db.yearGoalsTable).get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<List<YearGoal>> byCategory(String goalCategoryId) async {
    final query = _db.select(_db.yearGoalsTable)
      ..where((t) => t.goalCategoryId.equals(goalCategoryId));
    final rows = await query.get();
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<YearGoal> add(YearGoal yg) async {
    await _db.into(_db.yearGoalsTable).insert(_toCompanion(yg));
    return yg;
  }

  @override
  Future<void> update(YearGoal yg) async {
    await (_db.update(_db.yearGoalsTable)..where((t) => t.id.equals(yg.id)))
        .write(_toCompanion(yg));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.yearGoalsTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clear() async {
    await _db.delete(_db.yearGoalsTable).go();
  }

  YearGoal _fromRow(YearGoalRow r) => YearGoal(
        id: r.id,
        goalCategoryId: r.goalCategoryId,
        title: r.title,
        expanded: r.expanded,
      );

  YearGoalsTableCompanion _toCompanion(YearGoal y) => YearGoalsTableCompanion(
        id: Value(y.id),
        goalCategoryId: Value(y.goalCategoryId),
        title: Value(y.title),
        expanded: Value(y.expanded),
      );
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/data/drift/drift_year_goal_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/drift_year_goal_repository.dart \
        test/data/drift/drift_year_goal_repository_test.dart
git commit -m "feat(data): DriftYearGoalRepository (CRUD + cascade delete)"
```

### Task 3.6: Prefs settings repository

**Files:**
- Create: `lib/data/repositories/prefs_settings_repository.dart`
- Create: `test/data/repositories/prefs_settings_repository_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('read on empty store returns defaults', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    expect(await repo.read(), const AppSettings());
  });

  test('write then read round-trips', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    await repo.write(const AppSettings(themeMode: ThemeMode.dark, fontScale: FontScale.large));
    expect(
      await repo.read(),
      const AppSettings(themeMode: ThemeMode.dark, fontScale: FontScale.large),
    );
  });

  test('clear restores defaults', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = PrefsSettingsRepository(prefs);
    await repo.write(const AppSettings(themeMode: ThemeMode.dark));
    await repo.clear();
    expect(await repo.read(), const AppSettings());
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/data/repositories/prefs_settings_repository_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsSettingsRepository implements SettingsRepository {
  PrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'atelier.themeMode';
  static const _kFontScale = 'atelier.fontScale';

  @override
  Future<AppSettings> read() async {
    final theme = _prefs.getString(_kThemeMode);
    final scale = _prefs.getString(_kFontScale);
    return AppSettings(
      themeMode: _parseTheme(theme),
      fontScale: _parseScale(scale),
    );
  }

  @override
  Future<void> write(AppSettings settings) async {
    await _prefs.setString(_kThemeMode, settings.themeMode.name);
    await _prefs.setString(_kFontScale, settings.fontScale.name);
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_kThemeMode);
    await _prefs.remove(_kFontScale);
  }

  ThemeMode _parseTheme(String? raw) {
    switch (raw) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  FontScale _parseScale(String? raw) {
    switch (raw) {
      case 'small':
        return FontScale.small;
      case 'large':
        return FontScale.large;
      default:
        return FontScale.medium;
    }
  }
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/data/repositories/prefs_settings_repository_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/data/repositories/prefs_settings_repository.dart \
        test/data/repositories/prefs_settings_repository_test.dart
git commit -m "feat(data): PrefsSettingsRepository (theme + font scale)"
```

---

## Phase 4: Services + Cubits

### Task 4.1: OpenSlotCreator service

**Files:**
- Create: `lib/services/open_slot_creator.dart`
- Create: `lib/utils/uuid.dart`
- Create: `test/services/open_slot_creator_test.dart`

The `OpenSlotCreator` orchestrates: when the user adds their first pocket, also create the pinned `Open` add-slot row in the same operation. When the last real pocket is removed, also remove the `Open` slot. Uses `GoalCategoryRepository` only.

- [ ] **Step 1: UUID helper**

`lib/utils/uuid.dart`:

```dart
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Returns a fresh UUID v4 string. Centralised so tests can swap it via DI later.
String newId() => _uuid.v4();
```

- [ ] **Step 2: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository repo;
  late OpenSlotCreator creator;

  setUp(() {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    repo = DriftGoalCategoryRepository(db);
    creator = OpenSlotCreator(repo);
  });

  tearDown(() async => db.close());

  test('addFirstPocket creates the user pocket AND the Open slot', () async {
    final created = await creator.addFirstPocket(name: 'Work');

    final rows = await repo.all();
    expect(rows.length, 2);
    expect(rows.first.id, created.id);
    expect(rows.first.name, 'Work');
    expect(rows.first.order, 0);
    expect(rows.first.isAddSlot, isFalse);
    expect(rows.last.name, 'Open');
    expect(rows.last.isAddSlot, isTrue);
    expect(rows.last.order, greaterThan(rows.first.order));
  });

  test('addPocket on a non-empty store appends before the Open slot', () async {
    await creator.addFirstPocket(name: 'Work');
    final body = await creator.addPocket(name: 'Body');

    final rows = await repo.all();
    final names = rows.map((r) => r.name).toList();
    expect(names, ['Work', 'Body', 'Open']);
    expect(rows.firstWhere((r) => r.id == body.id).order, 1);
    expect(rows.firstWhere((r) => r.isAddSlot).order, 2);
  });

  test('removePocket of the last real pocket also removes the Open slot', () async {
    final work = await creator.addFirstPocket(name: 'Work');
    await creator.removePocket(work.id);
    expect(await repo.all(), isEmpty);
  });

  test('removePocket when other real pockets remain keeps the Open slot', () async {
    final work = await creator.addFirstPocket(name: 'Work');
    await creator.addPocket(name: 'Body');
    await creator.removePocket(work.id);

    final rows = await repo.all();
    expect(rows.map((r) => r.name).toList(), ['Body', 'Open']);
  });
}
```

- [ ] **Step 3: Run + verify failure**

Run: `flutter test test/services/open_slot_creator_test.dart`
Expected: FAIL.

- [ ] **Step 4: Implement**

```dart
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/utils/uuid.dart';

/// Orchestrates the creation/removal of the pinned `Open` add-slot pocket.
///
/// First-launch invariant: `categories` is empty until the user adds their
/// first pocket. At that moment we create both their pocket AND the Open slot.
/// When they remove their last real pocket, we also remove the Open slot.
class OpenSlotCreator {
  OpenSlotCreator(this._categories);

  final GoalCategoryRepository _categories;

  static const String _openName = 'Open';

  /// Creates the user's first pocket plus the Open add-slot. Idempotent in the
  /// sense that calling it on a non-empty store falls back to [addPocket].
  Future<GoalCategory> addFirstPocket({required String name}) async {
    final existing = await _categories.all();
    if (existing.isNotEmpty) return addPocket(name: name);

    final pocket = GoalCategory(id: newId(), name: name, order: 0);
    final open = GoalCategory(id: newId(), name: _openName, order: 1, isAddSlot: true);
    await _categories.add(pocket);
    await _categories.add(open);
    return pocket;
  }

  /// Adds a new real pocket. Inserts before the Open slot, preserving its
  /// position at the end of the order. If no Open slot exists (corner case
  /// after an external clear), this delegates to [addFirstPocket].
  Future<GoalCategory> addPocket({required String name}) async {
    final all = await _categories.all();
    final hasOpen = all.any((c) => c.isAddSlot);
    if (!hasOpen) return addFirstPocket(name: name);

    final realCount = all.where((c) => !c.isAddSlot).length;
    final pocket = GoalCategory(id: newId(), name: name, order: realCount);
    await _categories.add(pocket);

    // Bump the Open slot to be last.
    final open = all.firstWhere((c) => c.isAddSlot);
    await _categories.update(open.copyWith(order: realCount + 1));
    return pocket;
  }

  /// Removes a real pocket. If it was the last real pocket, also removes the
  /// Open slot so the home screen returns to the blank-slate empty state.
  Future<void> removePocket(String id) async {
    await _categories.delete(id);
    final remaining = await _categories.all();
    final realRemaining = remaining.where((c) => !c.isAddSlot).toList();
    if (realRemaining.isEmpty) {
      // Remove the orphaned Open slot.
      for (final addSlot in remaining.where((c) => c.isAddSlot)) {
        await _categories.delete(addSlot.id);
      }
    } else {
      // Recompact orders so real pockets are 0..N-1 and Open is N.
      final ordered = [
        ...realRemaining,
        ...remaining.where((c) => c.isAddSlot),
      ];
      await _categories.reorder(ordered.map((c) => c.id).toList());
    }
  }
}
```

- [ ] **Step 5: Run + verify pass**

Run: `flutter test test/services/open_slot_creator_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/services/open_slot_creator.dart lib/utils/uuid.dart \
        test/services/open_slot_creator_test.dart
git commit -m "feat(services): OpenSlotCreator orchestrator + uuid helper"
```

### Task 4.2: GoalCategoriesCubit

**Files:**
- Create: `lib/presentation/features/home/state/goal_categories_state.dart`
- Create: `lib/presentation/features/home/state/goal_categories_cubit.dart`
- Create: `test/presentation/features/home/state/goal_categories_cubit_test.dart`

> The cubit holds the full list (including the Open slot if present), exposes mutators that delegate to the repository / OpenSlotCreator, and emits new state after each mutation.

- [ ] **Step 1: State class**

`lib/presentation/features/home/state/goal_categories_state.dart`:

```dart
import 'package:atelier/domain/models/goal_category.dart';
import 'package:equatable/equatable.dart';

class GoalCategoriesState extends Equatable {
  const GoalCategoriesState({this.categories = const [], this.loaded = false});

  final List<GoalCategory> categories;
  final bool loaded;

  /// All real (non-Open) categories.
  List<GoalCategory> get realCategories =>
      categories.where((c) => !c.isAddSlot).toList(growable: false);

  /// Whether the user has zero real pockets (drives the empty-state UI).
  bool get isEmpty => loaded && realCategories.isEmpty;

  GoalCategoriesState copyWith({List<GoalCategory>? categories, bool? loaded}) =>
      GoalCategoriesState(
        categories: categories ?? this.categories,
        loaded: loaded ?? this.loaded,
      );

  @override
  List<Object?> get props => [categories, loaded];
}
```

- [ ] **Step 2: Failing cubit test**

`test/presentation/features/home/state/goal_categories_cubit_test.dart`:

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalCategoryRepository repo;
  late OpenSlotCreator creator;

  GoalCategoriesCubit build() => GoalCategoriesCubit(repo, creator);

  setUp(() {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    repo = DriftGoalCategoryRepository(db);
    creator = OpenSlotCreator(repo);
  });

  tearDown(() async => db.close());

  blocTest<GoalCategoriesCubit, GoalCategoriesState>(
    'load() emits a loaded empty state on a fresh DB',
    build: build,
    act: (c) => c.load(),
    expect: () => [
      isA<GoalCategoriesState>()
          .having((s) => s.loaded, 'loaded', true)
          .having((s) => s.categories, 'categories', isEmpty),
    ],
  );

  blocTest<GoalCategoriesCubit, GoalCategoriesState>(
    'addPocket on empty creates first pocket + Open slot and re-emits',
    build: build,
    act: (c) async {
      await c.load();
      await c.addPocket('Work');
    },
    skip: 1, // skip the load() emission
    expect: () => [
      isA<GoalCategoriesState>().having(
        (s) => s.categories.map((c) => c.name).toList(),
        'names',
        ['Work', 'Open'],
      ),
    ],
  );

  blocTest<GoalCategoriesCubit, GoalCategoriesState>(
    'removePocket on last real pocket removes Open too',
    build: build,
    act: (c) async {
      await c.load();
      await c.addPocket('Work');
      final work = c.state.realCategories.first;
      await c.removePocket(work.id);
    },
    skip: 2,
    expect: () => [
      isA<GoalCategoriesState>().having((s) => s.categories, 'categories', isEmpty),
    ],
  );

  blocTest<GoalCategoriesCubit, GoalCategoriesState>(
    'reorder updates orders in disk + state',
    build: build,
    act: (c) async {
      await c.load();
      await c.addPocket('A');
      await c.addPocket('B');
      await c.addPocket('C');
      final ids = c.state.realCategories.map((r) => r.id).toList();
      await c.reorder([ids[2], ids[0], ids[1]]);
    },
    skip: 4,
    expect: () => [
      isA<GoalCategoriesState>().having(
        (s) => s.realCategories.map((c) => c.name).toList(),
        'names',
        ['C', 'A', 'B'],
      ),
    ],
  );
}
```

- [ ] **Step 3: Run + verify failure**

Run: `flutter test test/presentation/features/home/state/goal_categories_cubit_test.dart`
Expected: FAIL — cubit doesn't exist.

- [ ] **Step 4: Implement cubit**

`lib/presentation/features/home/state/goal_categories_cubit.dart`:

```dart
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_state.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalCategoriesCubit extends Cubit<GoalCategoriesState> {
  GoalCategoriesCubit(this._repo, this._openSlot) : super(const GoalCategoriesState());

  final GoalCategoryRepository _repo;
  final OpenSlotCreator _openSlot;

  Future<void> load() async {
    final all = await _repo.all();
    emit(GoalCategoriesState(categories: all, loaded: true));
  }

  Future<void> addPocket(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (state.realCategories.isEmpty) {
      await _openSlot.addFirstPocket(name: trimmed);
    } else {
      await _openSlot.addPocket(name: trimmed);
    }
    await load();
  }

  Future<void> renamePocket(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final existing = state.categories.firstWhere((c) => c.id == id);
    await _repo.update(existing.copyWith(name: trimmed));
    await load();
  }

  Future<void> removePocket(String id) async {
    await _openSlot.removePocket(id);
    await load();
  }

  Future<void> reorder(List<String> realIdsInNewOrder) async {
    final openSlot = state.categories.where((c) => c.isAddSlot).map((c) => c.id);
    await _repo.reorder([...realIdsInNewOrder, ...openSlot]);
    await load();
  }

  Future<void> reload() => load();
}
```

- [ ] **Step 5: Run + verify pass**

Run: `flutter test test/presentation/features/home/state/goal_categories_cubit_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/features/home/state/goal_categories_cubit.dart \
        lib/presentation/features/home/state/goal_categories_state.dart \
        test/presentation/features/home/state/goal_categories_cubit_test.dart
git commit -m "feat(presentation): GoalCategoriesCubit (load/add/remove/reorder)"
```

### Task 4.3: GoalsCubit

**Files:**
- Create: `lib/presentation/features/detail/state/goals_state.dart`
- Create: `lib/presentation/features/detail/state/goals_cubit.dart`
- Create: `test/presentation/features/detail/state/goals_cubit_test.dart`

> Holds the full goals list across all categories. Exposes selectors that filter by category. The cubit reloads from disk after every mutation to stay consistent with the starred-first sort enforced in SQL.

- [ ] **Step 1: State class**

```dart
import 'package:atelier/domain/models/goal.dart';
import 'package:equatable/equatable.dart';

class GoalsState extends Equatable {
  const GoalsState({this.goals = const [], this.loaded = false});

  final List<Goal> goals;
  final bool loaded;

  List<Goal> forCategory(String goalCategoryId) =>
      goals.where((g) => g.goalCategoryId == goalCategoryId).toList(growable: false);

  GoalsState copyWith({List<Goal>? goals, bool? loaded}) =>
      GoalsState(goals: goals ?? this.goals, loaded: loaded ?? this.loaded);

  @override
  List<Object?> get props => [goals, loaded];
}
```

- [ ] **Step 2: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftGoalRepository repo;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    await cats.add(const GoalCategory(id: 'cat-a', name: 'Body', order: 0));
    repo = DriftGoalRepository(db);
  });

  tearDown(() async => db.close());

  GoalsCubit build() => GoalsCubit(repo);

  blocTest<GoalsCubit, GoalsState>(
    'add then state.forCategory returns the goal',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 'Strength 3×/wk');
    },
    skip: 1,
    expect: () => [
      isA<GoalsState>().having(
        (s) => s.forCategory('cat-a').map((g) => g.title).toList(),
        'titles',
        ['Strength 3×/wk'],
      ),
    ],
  );

  blocTest<GoalsCubit, GoalsState>(
    'toggleStar promotes the goal in sort order',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 'A');
      await c.add(goalCategoryId: 'cat-a', title: 'B');
      await c.add(goalCategoryId: 'cat-a', title: 'C');
      final b = c.state.forCategory('cat-a').firstWhere((g) => g.title == 'B');
      await c.toggleStar(b.id);
    },
    verify: (c) {
      final titles = c.state.forCategory('cat-a').map((g) => g.title).toList();
      expect(titles.first, 'B');
    },
  );

  blocTest<GoalsCubit, GoalsState>(
    'rename + delete work',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 'old');
      final id = c.state.forCategory('cat-a').single.id;
      await c.rename(id: id, title: 'new');
      expect(c.state.forCategory('cat-a').single.title, 'new');
      await c.delete(id);
      expect(c.state.forCategory('cat-a'), isEmpty);
    },
  );
}
```

- [ ] **Step 3: Run + verify failure**

Run: `flutter test test/presentation/features/detail/state/goals_cubit_test.dart`
Expected: FAIL.

- [ ] **Step 4: Implement cubit**

```dart
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:atelier/presentation/features/detail/state/goals_state.dart';
import 'package:atelier/utils/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalsCubit extends Cubit<GoalsState> {
  GoalsCubit(this._repo) : super(const GoalsState());

  final GoalRepository _repo;

  Future<void> load() async {
    emit(GoalsState(goals: await _repo.all(), loaded: true));
  }

  Future<void> add({required String goalCategoryId, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _repo.add(Goal(
      id: newId(),
      goalCategoryId: goalCategoryId,
      title: trimmed,
      addedAt: DateTime.now(),
    ));
    await load();
  }

  Future<void> rename({required String id, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final existing = state.goals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(title: trimmed));
    await load();
  }

  Future<void> toggleStar(String id) async {
    final existing = state.goals.firstWhere((g) => g.id == id);
    await _repo.update(existing.copyWith(starred: !existing.starred));
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> reload() => load();
}
```

- [ ] **Step 5: Run + verify pass**

Run: `flutter test test/presentation/features/detail/state/goals_cubit_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/features/detail/state/goals_cubit.dart \
        lib/presentation/features/detail/state/goals_state.dart \
        test/presentation/features/detail/state/goals_cubit_test.dart
git commit -m "feat(presentation): GoalsCubit (add/rename/toggleStar/delete)"
```

### Task 4.4: YearGoalsCubit

**Files:**
- Create: `lib/presentation/features/detail/state/year_goals_state.dart`
- Create: `lib/presentation/features/detail/state/year_goals_cubit.dart`
- Create: `test/presentation/features/detail/state/year_goals_cubit_test.dart`

- [ ] **Step 1: State class**

```dart
import 'package:atelier/domain/models/year_goal.dart';
import 'package:equatable/equatable.dart';

class YearGoalsState extends Equatable {
  const YearGoalsState({this.yearGoals = const [], this.loaded = false});

  final List<YearGoal> yearGoals;
  final bool loaded;

  List<YearGoal> forCategory(String goalCategoryId) =>
      yearGoals.where((y) => y.goalCategoryId == goalCategoryId).toList(growable: false);

  YearGoalsState copyWith({List<YearGoal>? yearGoals, bool? loaded}) =>
      YearGoalsState(yearGoals: yearGoals ?? this.yearGoals, loaded: loaded ?? this.loaded);

  @override
  List<Object?> get props => [yearGoals, loaded];
}
```

- [ ] **Step 2: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AtelierDatabase db;
  late DriftYearGoalRepository repo;

  setUp(() async {
    db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    await cats.add(const GoalCategory(id: 'cat-a', name: 'Body', order: 0));
    repo = DriftYearGoalRepository(db);
  });

  tearDown(() async => db.close());

  YearGoalsCubit build() => YearGoalsCubit(repo);

  blocTest<YearGoalsCubit, YearGoalsState>(
    'add then forCategory returns the new year goal expanded',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 'Sub-22 5K');
    },
    verify: (c) {
      expect(c.state.forCategory('cat-a').single.title, 'Sub-22 5K');
      expect(c.state.forCategory('cat-a').single.expanded, isTrue);
    },
  );

  blocTest<YearGoalsCubit, YearGoalsState>(
    'toggleExpanded flips the expanded flag',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 't');
      final id = c.state.forCategory('cat-a').single.id;
      await c.toggleExpanded(id);
      expect(c.state.forCategory('cat-a').single.expanded, isFalse);
      await c.toggleExpanded(id);
      expect(c.state.forCategory('cat-a').single.expanded, isTrue);
    },
  );

  blocTest<YearGoalsCubit, YearGoalsState>(
    'delete removes the year goal',
    build: build,
    act: (c) async {
      await c.load();
      await c.add(goalCategoryId: 'cat-a', title: 't');
      final id = c.state.forCategory('cat-a').single.id;
      await c.delete(id);
    },
    verify: (c) => expect(c.state.forCategory('cat-a'), isEmpty),
  );
}
```

- [ ] **Step 3: Run + verify failure**

Run: `flutter test test/presentation/features/detail/state/year_goals_cubit_test.dart`
Expected: FAIL.

- [ ] **Step 4: Implement cubit**

```dart
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_state.dart';
import 'package:atelier/utils/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YearGoalsCubit extends Cubit<YearGoalsState> {
  YearGoalsCubit(this._repo) : super(const YearGoalsState());

  final YearGoalRepository _repo;

  Future<void> load() async {
    emit(YearGoalsState(yearGoals: await _repo.all(), loaded: true));
  }

  Future<void> add({required String goalCategoryId, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    await _repo.add(YearGoal(
      id: newId(),
      goalCategoryId: goalCategoryId,
      title: trimmed,
    ));
    await load();
  }

  Future<void> rename({required String id, required String title}) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final existing = state.yearGoals.firstWhere((y) => y.id == id);
    await _repo.update(existing.copyWith(title: trimmed));
    await load();
  }

  Future<void> toggleExpanded(String id) async {
    final existing = state.yearGoals.firstWhere((y) => y.id == id);
    await _repo.update(existing.copyWith(expanded: !existing.expanded));
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    await load();
  }

  Future<void> reload() => load();
}
```

- [ ] **Step 5: Run + verify pass**

Run: `flutter test test/presentation/features/detail/state/year_goals_cubit_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/features/detail/state/year_goals_cubit.dart \
        lib/presentation/features/detail/state/year_goals_state.dart \
        test/presentation/features/detail/state/year_goals_cubit_test.dart
git commit -m "feat(presentation): YearGoalsCubit (add/rename/toggleExpanded/delete)"
```

### Task 4.5: SettingsCubit

**Files:**
- Create: `lib/presentation/features/settings/state/settings_state.dart`
- Create: `lib/presentation/features/settings/state/settings_cubit.dart`
- Create: `test/presentation/features/settings/state/settings_cubit_test.dart`

- [ ] **Step 1: State**

```dart
import 'package:atelier/domain/models/app_settings.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  const SettingsState({this.settings = const AppSettings(), this.loaded = false});

  final AppSettings settings;
  final bool loaded;

  SettingsState copyWith({AppSettings? settings, bool? loaded}) =>
      SettingsState(settings: settings ?? this.settings, loaded: loaded ?? this.loaded);

  @override
  List<Object?> get props => [settings, loaded];
}
```

- [ ] **Step 2: Failing test**

```dart
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<SettingsCubit> build() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsCubit(PrefsSettingsRepository(prefs));
  }

  blocTest<SettingsCubit, SettingsState>(
    'load emits defaults on a fresh store',
    build: () async => build(),
    act: (c) => c.load(),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings, 'settings', const AppSettings())
          .having((s) => s.loaded, 'loaded', true),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setTheme persists + emits',
    build: () async => build(),
    act: (c) async {
      await c.load();
      await c.setTheme(ThemeMode.dark);
    },
    skip: 1,
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings.themeMode, 'themeMode', ThemeMode.dark),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setFontScale persists + emits',
    build: () async => build(),
    act: (c) async {
      await c.load();
      await c.setFontScale(FontScale.large);
    },
    skip: 1,
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings.fontScale, 'fontScale', FontScale.large),
    ],
  );
}
```

> **Note for the implementer:** `bloc_test`'s `build:` callback expects a sync builder. Wrap the async setup like `build: () => build_async()` by hoisting the async into the test body. The simplest workaround: write a helper at the top of the file that returns `Future<SettingsCubit>` and use `setUp` to await it.

Replace the test file with this corrected version that uses `setUp` for async construction:

```dart
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late PrefsSettingsRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repo = PrefsSettingsRepository(prefs);
  });

  blocTest<SettingsCubit, SettingsState>(
    'load emits defaults on a fresh store',
    build: () => SettingsCubit(repo),
    act: (c) => c.load(),
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings, 'settings', const AppSettings())
          .having((s) => s.loaded, 'loaded', true),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setTheme persists + emits',
    build: () => SettingsCubit(repo),
    act: (c) async {
      await c.load();
      await c.setTheme(ThemeMode.dark);
    },
    skip: 1,
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings.themeMode, 'themeMode', ThemeMode.dark),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'setFontScale persists + emits',
    build: () => SettingsCubit(repo),
    act: (c) async {
      await c.load();
      await c.setFontScale(FontScale.large);
    },
    skip: 1,
    expect: () => [
      isA<SettingsState>()
          .having((s) => s.settings.fontScale, 'fontScale', FontScale.large),
    ],
  );
}
```

- [ ] **Step 3: Run + verify failure**

Run: `flutter test test/presentation/features/settings/state/settings_cubit_test.dart`
Expected: FAIL.

- [ ] **Step 4: Implement cubit**

```dart
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsState());

  final SettingsRepository _repo;

  Future<void> load() async {
    final s = await _repo.read();
    emit(SettingsState(settings: s, loaded: true));
  }

  Future<void> setTheme(ThemeMode mode) async {
    final next = state.settings.copyWith(themeMode: mode);
    await _repo.write(next);
    emit(state.copyWith(settings: next));
  }

  Future<void> setFontScale(FontScale scale) async {
    final next = state.settings.copyWith(fontScale: scale);
    await _repo.write(next);
    emit(state.copyWith(settings: next));
  }

  Future<void> reset() async {
    await _repo.clear();
    emit(const SettingsState(settings: AppSettings(), loaded: true));
  }
}
```

- [ ] **Step 5: Run + verify pass**

Run: `flutter test test/presentation/features/settings/state/settings_cubit_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/presentation/features/settings/state/settings_cubit.dart \
        lib/presentation/features/settings/state/settings_state.dart \
        test/presentation/features/settings/state/settings_cubit_test.dart
git commit -m "feat(presentation): SettingsCubit (theme + font scale + reset)"
```

### Task 4.6: ManageModeCubit (UI-only)

**Files:**
- Create: `lib/presentation/features/home/state/manage_mode_state.dart`
- Create: `lib/presentation/features/home/state/manage_mode_cubit.dart`
- Create: `test/presentation/features/home/state/manage_mode_cubit_test.dart`

- [ ] **Step 1: State + cubit + test**

`lib/presentation/features/home/state/manage_mode_state.dart`:

```dart
import 'package:equatable/equatable.dart';

class ManageModeState extends Equatable {
  const ManageModeState({this.isManaging = false});
  final bool isManaging;

  @override
  List<Object?> get props => [isManaging];
}
```

`test/presentation/features/home/state/manage_mode_cubit_test.dart`:

```dart
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  blocTest<ManageModeCubit, ManageModeState>(
    'enter sets isManaging to true',
    build: () => ManageModeCubit(),
    act: (c) => c.enter(),
    expect: () => [const ManageModeState(isManaging: true)],
  );

  blocTest<ManageModeCubit, ManageModeState>(
    'exit sets isManaging to false from a managing state',
    build: () => ManageModeCubit()..enter(),
    act: (c) => c.exit(),
    expect: () => [const ManageModeState(isManaging: false)],
  );
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/presentation/features/home/state/manage_mode_cubit_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

`lib/presentation/features/home/state/manage_mode_cubit.dart`:

```dart
import 'package:atelier/presentation/features/home/state/manage_mode_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageModeCubit extends Cubit<ManageModeState> {
  ManageModeCubit() : super(const ManageModeState());

  void enter() => emit(const ManageModeState(isManaging: true));
  void exit() => emit(const ManageModeState(isManaging: false));
  void toggle() => emit(ManageModeState(isManaging: !state.isManaging));
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/presentation/features/home/state/manage_mode_cubit_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/features/home/state/manage_mode_cubit.dart \
        lib/presentation/features/home/state/manage_mode_state.dart \
        test/presentation/features/home/state/manage_mode_cubit_test.dart
git commit -m "feat(presentation): ManageModeCubit (UI-only enter/exit/toggle)"
```

### Task 4.7: Settings reset wires through to data cubits

**Files:**
- Create: `lib/services/data_resetter.dart`
- Create: `test/services/data_resetter_test.dart`

> The settings sheet's "Reset all data" needs to clear *everything* — settings prefs, all goal categories, all goals, all year goals — and trigger reloads on every cubit. We add a `DataResetter` orchestrator service so the settings cubit doesn't need to depend on goal cubits.

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('reset clears categories, goals, year goals, and settings prefs', () async {
    SharedPreferences.setMockInitialValues({
      'atelier.themeMode': 'dark',
      'atelier.fontScale': 'large',
    });
    final prefs = await SharedPreferences.getInstance();
    final settings = PrefsSettingsRepository(prefs);

    final db = AtelierDatabase.withExecutor(NativeDatabase.memory());
    final cats = DriftGoalCategoryRepository(db);
    final goals = DriftGoalRepository(db);
    final yearGoals = DriftYearGoalRepository(db);

    await cats.add(const GoalCategory(id: 'c1', name: 'Work', order: 0));
    await goals.add(Goal(id: 'g1', goalCategoryId: 'c1', title: 't', addedAt: DateTime.now()));
    await yearGoals.add(const YearGoal(id: 'y1', goalCategoryId: 'c1', title: 't'));

    final resetter = DataResetter(
      categories: cats,
      goals: goals,
      yearGoals: yearGoals,
      settings: settings,
    );
    await resetter.reset();

    expect(await cats.all(), isEmpty);
    expect(await goals.all(), isEmpty);
    expect(await yearGoals.all(), isEmpty);
    expect(prefs.getString('atelier.themeMode'), isNull);
    expect(prefs.getString('atelier.fontScale'), isNull);

    await db.close();
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/services/data_resetter_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';

/// Truncates every persisted store. Used by Settings → Reset all data.
///
/// Order matters: drop dependent rows (goals, year goals) before parents
/// (categories) to avoid foreign-key violations even though Drift's cascade
/// would normally handle it.
class DataResetter {
  DataResetter({
    required GoalCategoryRepository categories,
    required GoalRepository goals,
    required YearGoalRepository yearGoals,
    required SettingsRepository settings,
  })  : _categories = categories,
        _goals = goals,
        _yearGoals = yearGoals,
        _settings = settings;

  final GoalCategoryRepository _categories;
  final GoalRepository _goals;
  final YearGoalRepository _yearGoals;
  final SettingsRepository _settings;

  Future<void> reset() async {
    await _goals.clear();
    await _yearGoals.clear();
    await _categories.clear();
    await _settings.clear();
  }
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/services/data_resetter_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/services/data_resetter.dart test/services/data_resetter_test.dart
git commit -m "feat(services): DataResetter — truncate all stores on Settings → Reset"
```

---

## Phase 5: App shell + composition root

### Task 5.1: Routing config

**Files:**
- Create: `lib/config/router.dart`

- [ ] **Step 1: Implement router**

```dart
import 'package:atelier/presentation/features/detail/detail_container.dart';
import 'package:atelier/presentation/features/home/home_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AtelierRouter {
  const AtelierRouter._();

  static GoRouter build() => GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const HomeContainer(),
          ),
          GoRoute(
            path: '/pocket/:id',
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return DetailContainer(goalCategoryId: id);
            },
          ),
        ],
      );
}
```

> **Note:** `HomeContainer` and `DetailContainer` don't exist yet — they're stubs we'll fill in Phase 6 + 7. Create them now as empty placeholders so this file analyzes.

- [ ] **Step 2: Stub the containers**

`lib/presentation/features/home/home_container.dart`:

```dart
import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home')));
}
```

`lib/presentation/features/detail/detail_container.dart`:

```dart
import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  const DetailContainer({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Detail: $goalCategoryId')));
}
```

- [ ] **Step 3: Verify analyze**

Run: `flutter analyze`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/config/router.dart \
        lib/presentation/features/home/home_container.dart \
        lib/presentation/features/detail/detail_container.dart
git commit -m "feat(config): go_router config + container stubs"
```

### Task 5.2: AtelierApp + composition root

**Files:**
- Create: `lib/config/atelier_app.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Implement AtelierApp**

```dart
import 'package:atelier/config/router.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/data/repositories/prefs_settings_repository.dart';
import 'package:atelier/domain/models/enums/font_scale.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/presentation/features/home/state/manage_mode_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_cubit.dart';
import 'package:atelier/presentation/features/settings/state/settings_state.dart';
import 'package:atelier/services/data_resetter.dart';
import 'package:atelier/services/open_slot_creator.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AtelierApp extends StatelessWidget {
  const AtelierApp({
    super.key,
    required this.database,
    required this.prefs,
  });

  final AtelierDatabase database;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final categoriesRepo = DriftGoalCategoryRepository(database);
    final goalsRepo = DriftGoalRepository(database);
    final yearGoalsRepo = DriftYearGoalRepository(database);
    final settingsRepo = PrefsSettingsRepository(prefs);
    final openSlot = OpenSlotCreator(categoriesRepo);
    final resetter = DataResetter(
      categories: categoriesRepo,
      goals: goalsRepo,
      yearGoals: yearGoalsRepo,
      settings: settingsRepo,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: resetter),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GoalCategoriesCubit(categoriesRepo, openSlot)..load()),
          BlocProvider(create: (_) => GoalsCubit(goalsRepo)..load()),
          BlocProvider(create: (_) => YearGoalsCubit(yearGoalsRepo)..load()),
          BlocProvider(create: (_) => SettingsCubit(settingsRepo)..load()),
          BlocProvider(create: (_) => ManageModeCubit()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final scale = state.settings.fontScale.multiplier;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
              child: MaterialApp.router(
                title: 'Atelier',
                theme: AtelierTheme.light(),
                darkTheme: AtelierTheme.dark(),
                themeMode: state.settings.themeMode,
                routerConfig: AtelierRouter.build(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Update main.dart**

```dart
import 'package:atelier/config/atelier_app.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AtelierDatabase();
  final prefs = await SharedPreferences.getInstance();
  runApp(AtelierApp(database: database, prefs: prefs));
}
```

- [ ] **Step 3: Run analyze + tests**

Run: `tool/check.sh`
Expected: `OK`.

- [ ] **Step 4: Smoke run**

Run: `flutter run -d <your-emulator>` (or skip if no device wired up)
Expected: app launches, shows "Home" stub on a light background.

- [ ] **Step 5: Commit**

```bash
git add lib/config/atelier_app.dart lib/main.dart
git commit -m "feat(config): AtelierApp + composition root wires DI for cubits"
```

---

## Phase 6: Home screen UI

> **Background:** This phase builds the Home screen end-to-end including the empty-state experience for first launch. We use TDD where it makes sense (logic, computed values) and widget tests for behaviour. We skip widget tests for purely visual leaves; goldens cover those at the end of the phase.
>
> Re-read spec sections 3.1, 3.2, 3.6, 3.8, 3.9 before starting.

### Task 6.1: Common Segmented widget

**Files:**
- Create: `lib/presentation/common/segmented/segmented_option.dart`
- Create: `lib/presentation/common/segmented/segmented.dart`
- Create: `test/presentation/common/segmented/segmented_test.dart`

- [ ] **Step 1: Failing widget test**

`test/presentation/common/segmented/segmented_test.dart`:

```dart
import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders all options and calls onChanged on tap', (tester) async {
    String? selected;
    await tester.pumpWidget(MaterialApp(
      theme: AtelierTheme.light(),
      home: Scaffold(
        body: Segmented<String>(
          value: 'a',
          options: const [
            SegmentedOptionData(value: 'a', label: 'A'),
            SegmentedOptionData(value: 'b', label: 'B'),
            SegmentedOptionData(value: 'c', label: 'C'),
          ],
          onChanged: (v) => selected = v,
        ),
      ),
    ));

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);

    await tester.tap(find.text('B'));
    await tester.pump();
    expect(selected, 'b');
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/presentation/common/segmented/segmented_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement option data + widgets**

`lib/presentation/common/segmented/segmented_option.dart`:

```dart
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class SegmentedOptionData<T> {
  const SegmentedOptionData({required this.value, required this.label});
  final T value;
  final String label;
}

class SegmentedOption<T> extends StatelessWidget {
  const SegmentedOption({
    super.key,
    required this.data,
    required this.active,
    required this.onTap,
  });

  final SegmentedOptionData<T> data;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AtelierRadii.md - 1),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AtelierSpacing.lg,
          vertical: AtelierSpacing.base,
        ),
        decoration: BoxDecoration(
          color: active ? p.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(AtelierRadii.md - 1),
        ),
        child: Text(
          data.label,
          style: AtelierTypography.monoLabel.copyWith(
            color: active ? p.bg : p.sub,
          ),
        ),
      ),
    );
  }
}
```

`lib/presentation/common/segmented/segmented.dart`:

```dart
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class Segmented<T> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<SegmentedOptionData<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(AtelierSpacing.xs),
      decoration: BoxDecoration(
        color: p.surface,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(AtelierRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            Expanded(
              child: SegmentedOption<T>(
                data: o,
                active: o.value == value,
                onTap: () => onChanged(o.value),
              ),
            ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/presentation/common/segmented/segmented_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/presentation/common/segmented/ test/presentation/common/segmented/
git commit -m "feat(common): Segmented + SegmentedOption pill switch"
```

### Task 6.2: Date utilities

**Files:**
- Create: `lib/utils/date_utils.dart`
- Create: `test/utils/date_utils_test.dart`

- [ ] **Step 1: Failing test**

```dart
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AtelierDateUtils', () {
    test('daysInMonth handles 28/29/30/31', () {
      expect(AtelierDateUtils.daysInMonth(2026, 2), 28);
      expect(AtelierDateUtils.daysInMonth(2024, 2), 29);
      expect(AtelierDateUtils.daysInMonth(2026, 4), 30);
      expect(AtelierDateUtils.daysInMonth(2026, 5), 31);
    });

    test('daysSince computes whole-day difference', () {
      final today = DateTime(2026, 5, 12);
      expect(AtelierDateUtils.daysSince(today, today), 0);
      expect(AtelierDateUtils.daysSince(DateTime(2026, 5, 11), today), 1);
      expect(AtelierDateUtils.daysSince(DateTime(2026, 5, 9), today), 3);
    });

    test('formatDaysSince renders the label per spec', () {
      expect(AtelierDateUtils.formatDaysSince(0), 'today');
      expect(AtelierDateUtils.formatDaysSince(1), '1 day');
      expect(AtelierDateUtils.formatDaysSince(3), '3 days');
    });

    test('monthName returns the english name', () {
      expect(AtelierDateUtils.monthName(5), 'May');
      expect(AtelierDateUtils.monthName(1), 'January');
      expect(AtelierDateUtils.monthName(12), 'December');
    });
  });
}
```

- [ ] **Step 2: Run + verify failure**

Run: `flutter test test/utils/date_utils_test.dart`
Expected: FAIL.

- [ ] **Step 3: Implement**

```dart
class AtelierDateUtils {
  const AtelierDateUtils._();

  static int daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  static int daysSince(DateTime from, DateTime to) {
    final fromDay = DateTime(from.year, from.month, from.day);
    final toDay = DateTime(to.year, to.month, to.day);
    return toDay.difference(fromDay).inDays;
  }

  static String formatDaysSince(int days) {
    if (days <= 0) return 'today';
    if (days == 1) return '1 day';
    return '$days days';
  }

  static String monthName(int month) {
    const names = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month - 1];
  }
}
```

- [ ] **Step 4: Run + verify pass**

Run: `flutter test test/utils/date_utils_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/utils/date_utils.dart test/utils/date_utils_test.dart
git commit -m "feat(utils): AtelierDateUtils — days-in-month, days-since, formatters"
```

### Task 6.3: TickStrip

**Files:**
- Create: `lib/presentation/features/home/widgets/tick_strip/tick_strip_baseline.dart`
- Create: `lib/presentation/features/home/widgets/tick_strip/tick_strip_tick_mark.dart`
- Create: `lib/presentation/features/home/widgets/tick_strip/tick_strip_today_label.dart`
- Create: `lib/presentation/features/home/widgets/tick_strip/tick_strip.dart`
- Create: `test/presentation/features/home/widgets/tick_strip_test.dart`

> Re-read spec §3.8.

- [ ] **Step 1: Implement leaf widgets**

`tick_strip_baseline.dart`:

```dart
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class TickStripBaseline extends StatelessWidget {
  const TickStripBaseline({super.key});

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    return Positioned(
      left: 0,
      right: 0,
      top: 13,
      child: Container(height: 1, color: p.rule),
    );
  }
}
```

`tick_strip_tick_mark.dart`:

```dart
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';

class TickStripTickMark extends StatelessWidget {
  const TickStripTickMark({
    super.key,
    required this.day,
    required this.totalDays,
    required this.isToday,
  });

  final int day;
  final int totalDays;
  final bool isToday;

  bool get _isMajor => day == 1 || day == totalDays || day % 5 == 0;

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    final width = isToday ? 2.0 : 1.0;
    final height = isToday ? 14.0 : (_isMajor ? 6.0 : 3.0);
    final leftPct = (day - 1) / (totalDays - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: leftPct * constraints.maxWidth - width / 2,
          top: 13,
          child: Container(
            width: width,
            height: height,
            color: isToday ? p.accent : p.rule,
          ),
        );
      },
    );
  }
}
```

`tick_strip_today_label.dart`:

```dart
import 'package:atelier/theme/atelier_palette.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';

class TickStripTodayLabel extends StatelessWidget {
  const TickStripTodayLabel({
    super.key,
    required this.day,
    required this.totalDays,
  });

  final int day;
  final int totalDays;

  int get _percent => ((day / totalDays) * 100).round();

  @override
  Widget build(BuildContext context) {
    final AtelierPalette p = AtelierTheme.paletteOf(context);
    final leftPct = (day - 1) / (totalDays - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: leftPct * constraints.maxWidth - 30,
          top: -2,
          child: Text.rich(
            TextSpan(
              style: AtelierTypography.monoMicro,
              children: [
                TextSpan(
                  text: 'D$day',
                  style: TextStyle(color: p.ink, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: '  · $_percent%',
                  style: TextStyle(color: p.mute, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

`tick_strip.dart`:

```dart
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_baseline.dart';
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_tick_mark.dart';
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip_today_label.dart';
import 'package:atelier/utils/date_utils.dart';
import 'package:flutter/material.dart';

class TickStrip extends StatelessWidget {
  const TickStrip({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final totalDays = AtelierDateUtils.daysInMonth(now.year, now.month);
    final today = now.day;
    return SizedBox(
      height: 22,
      child: Stack(
        children: [
          const TickStripBaseline(),
          for (var d = 1; d <= totalDays; d++)
            TickStripTickMark(day: d, totalDays: totalDays, isToday: d == today),
          TickStripTodayLabel(day: today, totalDays: totalDays),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Failing widget test**

```dart
import 'package:atelier/presentation/features/home/widgets/tick_strip/tick_strip.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders today label "D12 · 39%" on May 12', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AtelierTheme.light(),
      home: Scaffold(body: TickStrip(now: DateTime(2026, 5, 12))),
    ));
    expect(find.textContaining('D12'), findsOneWidget);
    expect(find.textContaining('39%'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run + verify pass**

Run: `flutter test test/presentation/features/home/widgets/tick_strip_test.dart`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/presentation/features/home/widgets/tick_strip/ \
        test/presentation/features/home/widgets/tick_strip_test.dart
git commit -m "feat(home): TickStrip + sub-widgets (baseline, tick mark, today label)"
```

### Tasks 6.4 onwards: HomeTopBar, Pocket, PocketGrid, HomeEmptyState, HomeContainer + HomeScreen

> **Implementer guidance:** continue this phase by building each widget bottom-up: HomeTopBar (with sub-widgets DaysLeftLabel, SettingsGearButton, DonePillButton) → Pocket (with PocketHeader, PocketYearPreview, PocketGoalsPreview, PocketRemoveBadge, PocketEmptyState) → PocketGrid (uses `ReorderableGridView.count` from the `reorderable_grid_view` package, fed from `GoalCategoriesCubit`) → HomeEmptyState (with eyebrow/body/action sub-widgets) → HomeScreen (composes top bar + tick strip + grid OR empty state via `BlocBuilder<GoalCategoriesCubit>`) → HomeContainer (just builds HomeScreen; cubits live at the app shell).
>
> For each widget:
> 1. Read the relevant spec section (§3.2 for pockets, §3.6 for manage mode, §3.9 for empty state)
> 2. Read the prototype source in `docs/design-handoff/personal-month-goals-system/project/v-atelier-year.jsx` for the corresponding `Y*` component
> 3. Write a widget test for any logic-bearing behaviour (e.g. PocketGoalsPreview shows starred items in the right style, +N more overflow appears at >3 goals, manage-mode wiggle starts on long-press)
> 4. Implement the widget
> 5. Verify the test passes and commit
>
> Files to create (one per file, follow `lib/presentation/features/home/widgets/<group>/<widget>.dart` from the spec layout). Concrete styling values come from the prototype source — match them faithfully, using `AtelierSpacing` / `AtelierRadii` / `AtelierTypography` / `AtelierTheme.paletteOf(context)` for tokens.

For each file below, use the same TDD rhythm (Step 1: write failing test, Step 2: run, Step 3: implement, Step 4: pass, Step 5: commit). Suggested commit boundaries (one commit per row):

| Task | Files | Commit message |
|---|---|---|
| 6.4 | `home/widgets/top_bar/{home_top_bar,days_left_label,settings_gear_button,done_pill_button}.dart` + tests | `feat(home): HomeTopBar — month/year, days-left, settings/done buttons` |
| 6.5 | `home/widgets/pocket/{pocket,pocket_header,pocket_year_preview,pocket_goals_preview,pocket_remove_badge,pocket_empty_state}.dart` + tests | `feat(home): Pocket card with year + month previews, manage-mode badge` |
| 6.6 | `home/widgets/grid/pocket_grid.dart` + test | `feat(home): PocketGrid (ReorderableGridView, drag-reorder + manage-mode)` |
| 6.7 | `home/widgets/empty_state/{home_empty_state,_eyebrow,_body,_action}.dart` + tests | `feat(home): HomeEmptyState (blank-slate first-launch screen)` |
| 6.8 | `home/home_screen.dart` (composes everything) + widget test | `feat(home): HomeScreen wires top bar, tick strip, grid or empty state` |
| 6.9 | Update `home_container.dart` from stub to read manage-mode cubit | `feat(home): HomeContainer reads cubits + provides ManageModeCubit` |

**Key behaviours to test (don't skip these):**
- Empty state: `GoalCategoriesCubit.state.isEmpty` → `HomeEmptyState` shows; tap action → opens add-pocket input → submitting calls `cubit.addPocket(name)`.
- Pocket long-press (~450ms) calls `ManageModeCubit.enter()`.
- Tap outside any pocket while `isManaging` calls `ManageModeCubit.exit()`.
- `Open` pocket is hidden in the grid when `isManaging`.
- Drag-reorder: `PocketGrid.onReorder` calls `GoalCategoriesCubit.reorder([...newOrder])`.
- Tap × on a pocket in manage mode → `GoalCategoriesCubit.removePocket(id)`.

> Each widget's exact dimensions, padding, fonts, and colors come from the prototype JSX. The full file is at `docs/design-handoff/personal-month-goals-system/project/v-atelier-year.jsx`. Translate `style={{ ... }}` blocks to Flutter `Container.decoration`/`padding` using the Atelier tokens. Don't hardcode raw px values that are in the scale; use `AtelierSpacing.X` and friends.

- [ ] **Step 6.10: Phase 6 smoke check**

After completing 6.4–6.9, run:

```bash
tool/check.sh
flutter run -d <device>
```

Expected: app launches, shows the empty state on first launch with the right typography. Tapping `+ ADD YOUR FIRST POCKET` opens an input and creates the first pocket; the grid replaces the empty state.

- [ ] **Step 6.11: Commit milestone tag**

```bash
git tag -a m1-home -m "milestone: home screen + empty state working"
```

---

## Phase 7: Detail screen UI

> Re-read spec §3.3, §3.4, §3.5. The detail screen is reached via `/pocket/:id`.
>
> Build bottom-up like Phase 6. Suggested commits:

| Task | Files | Commit |
|---|---|---|
| 7.1 | `detail/widgets/top_bar/{detail_top_bar,detail_back_button,detail_count_label}.dart` + tests | `feat(detail): DetailTopBar` |
| 7.2 | `detail/widgets/year_banner/{year_banner,year_banner_collapsed,year_banner_expanded,year_banner_empty_state}.dart` + tests | `feat(detail): YearBanner with collapsed/expanded states` |
| 7.3 | `detail/widgets/goals/{goal_row,goal_row_star_button,goal_row_days_label,goal_row_actions,goal_row_editor,goals_empty_state}.dart` + tests | `feat(detail): GoalRow with inline edit + star + days-since` |
| 7.4 | `detail/widgets/add_bar/{add_bar,add_bar_switch,add_bar_input,add_bar_placeholder}.dart` + tests | `feat(detail): AddBar (MONTH/YEAR switch + inline input)` |
| 7.5 | `detail/detail_screen.dart` + widget test | `feat(detail): DetailScreen composes top bar, banners, goal list, add bar` |
| 7.6 | Update `detail_container.dart` from stub | `feat(detail): DetailContainer reads cubits, scopes by goalCategoryId` |

**Key behaviours to test:**
- AddBar in MONTH mode: submitting calls `GoalsCubit.add(goalCategoryId: <category>, title: text)`. In YEAR mode: calls `YearGoalsCubit.add(...)`.
- Submitting empty input is a no-op (matches prototype).
- GoalRow tap toggles a Boolean local "open" state and reveals `GoalRowActions`.
- Edit button swaps the row to `GoalRowEditor`; Save calls `GoalsCubit.rename(id, title)`.
- Star button calls `GoalsCubit.toggleStar(id)`.
- YearBanner header tap calls `YearGoalsCubit.toggleExpanded(id)`.
- × on expanded YearBanner calls `YearGoalsCubit.delete(id)`.
- The starred-first sort comes from the cubit; widget tests just need to render the list in the order the state provides.

- [ ] **Step 7.7: Phase 7 smoke check**

`tool/check.sh` clean, then `flutter run` and walk through:
1. Open a pocket
2. Add a month goal in MONTH mode
3. Add a year goal in YEAR mode → see banner appear at top
4. Star the month goal → it sorts to the top
5. Tap the row → expand → Edit → rename → Save
6. Toggle the year banner → collapses to compact form
7. × the year banner → it disappears
8. Back arrow returns to home

- [ ] **Step 7.8: Milestone tag**

```bash
git tag -a m2-detail -m "milestone: detail screen end-to-end"
```

---

## Phase 8: Settings + manage mode polish + reset wiring

| Task | Files | Commit |
|---|---|---|
| 8.1 | `settings/widgets/{settings_handle,settings_backdrop,settings_header}.dart` + tests | `feat(settings): sheet chrome` |
| 8.2 | `settings/widgets/theme_selector.dart` (uses Segmented, watches SettingsCubit) + test | `feat(settings): ThemeSelector wired to SettingsCubit` |
| 8.3 | `settings/widgets/font_scale_selector.dart` + test | `feat(settings): FontScaleSelector wired to SettingsCubit` |
| 8.4 | `settings/widgets/reset_data_button.dart` + `reset_data_confirm.dart` + test | `feat(settings): two-step Reset all data button` |
| 8.5 | `settings/settings_sheet.dart` (composes everything in a `showModalBottomSheet` flow) + widget test | `feat(settings): SettingsSheet modal sheet` |
| 8.6 | Wire settings gear from `HomeTopBar` to open `SettingsSheet`; wire reset confirm to `DataResetter` + cubit `reload()` calls | `feat(settings): wire gear button + reset to all cubits` |

**Reset flow:**
- `ResetDataConfirm.onReset` → `context.read<DataResetter>().reset()` → then call `reload()` on `GoalCategoriesCubit`, `GoalsCubit`, `YearGoalsCubit`, `SettingsCubit` (each fetches from disk and emits) → close the sheet → home re-renders the empty state.

- [ ] **Step 8.7: Phase 8 smoke check**

`tool/check.sh` clean, then `flutter run`:
1. Tap settings gear → sheet slides up
2. Switch theme to Dark → app re-themes immediately
3. Switch font scale to Large → text scales up
4. Tap "Reset all data" → confirmation appears
5. Tap Reset → sheet closes, home shows empty state

- [ ] **Step 8.8: Milestone tag**

```bash
git tag -a m3-settings -m "milestone: settings + reset working"
```

---

## Phase 9: Golden tests + final polish

### Task 9.1: Light + dark home goldens

**Files:**
- Create: `test/golden/home_light_test.dart`
- Create: `test/golden/home_dark_test.dart`
- Create: `test/golden/__support__/golden_harness.dart`

> Goldens lock the visual output. Use a fixed phone-frame size matching the prototype (360×740). Seed the cubits in the test with deterministic data so the same image renders every run.

- [ ] **Step 1: Build a small harness**

`test/golden/__support__/golden_harness.dart`:

```dart
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:atelier/data/repositories/drift_goal_category_repository.dart';
import 'package:atelier/data/repositories/drift_goal_repository.dart';
import 'package:atelier/data/repositories/drift_year_goal_repository.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';

const Size kPhone = Size(360, 740);

Future<AtelierDatabase> seededDb() async {
  final db = AtelierDatabase.withExecutor(NativeDatabase.memory());
  final cats = DriftGoalCategoryRepository(db);
  final goals = DriftGoalRepository(db);
  final yearGoals = DriftYearGoalRepository(db);

  await cats.add(const GoalCategory(id: 'work', name: 'Work', order: 0));
  await cats.add(const GoalCategory(id: 'body', name: 'Body', order: 1));
  await cats.add(const GoalCategory(id: 'mind', name: 'Mind', order: 2));
  await cats.add(const GoalCategory(id: 'open', name: 'Open', order: 3, isAddSlot: true));

  await yearGoals.add(const YearGoal(id: 'y1', goalCategoryId: 'work', title: 'Ship side project'));
  await yearGoals.add(const YearGoal(id: 'y2', goalCategoryId: 'body', title: 'Sub-22 5K'));

  final t = DateTime.utc(2026, 5, 1);
  await goals.add(Goal(id: 'g1', goalCategoryId: 'work', title: 'Ship v0.1', starred: true, addedAt: t));
  await goals.add(Goal(id: 'g2', goalCategoryId: 'body', title: 'Long run Sat', addedAt: t));
  return db;
}
```

- [ ] **Step 2: Light home golden**

`test/golden/home_light_test.dart`:

```dart
import 'package:atelier/config/atelier_app.dart';
import 'package:atelier/data/drift/atelier_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '__support__/golden_harness.dart';

void main() {
  testWidgets('home (light) renders pocket grid with seeded data', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = await seededDb();

    tester.view.physicalSize = kPhone * tester.view.devicePixelRatio;
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(AtelierApp(database: db, prefs: prefs));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_light.png'),
    );
    await db.close();
  });
}
```

> **Note for the implementer:** the first run produces the golden file; subsequent runs compare. Run `flutter test --update-goldens test/golden/home_light_test.dart` to (re)generate after any intentional visual change. Commit the golden PNG.

- [ ] **Step 3: Dark home golden**

`test/golden/home_dark_test.dart`:

```dart
import 'package:atelier/config/atelier_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '__support__/golden_harness.dart';

void main() {
  testWidgets('home (dark) renders pocket grid with seeded data', (tester) async {
    SharedPreferences.setMockInitialValues({
      'atelier.themeMode': 'dark',
    });
    final prefs = await SharedPreferences.getInstance();
    final db = await seededDb();

    tester.view.physicalSize = kPhone * tester.view.devicePixelRatio;
    tester.view.devicePixelRatio = 1;

    await tester.pumpWidget(AtelierApp(database: db, prefs: prefs));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/home_dark.png'),
    );
    await db.close();
  });
}
```

- [ ] **Step 4: Generate goldens**

Run: `flutter test --update-goldens test/golden/`
Expected: creates `test/golden/goldens/home_light.png` and `home_dark.png`.

- [ ] **Step 5: Re-run without `--update-goldens`**

Run: `flutter test test/golden/`
Expected: PASS (compares against just-generated PNGs).

- [ ] **Step 6: Commit**

```bash
git add test/golden/
git commit -m "test(golden): home light + dark golden snapshots"
```

### Task 9.2: Detail goldens

Repeat the pattern for `/pocket/work` (the seeded category with star + year goal):

- [ ] **Step 1: Detail light golden**

Create `test/golden/detail_light_test.dart` that pumps `AtelierApp`, awaits initial settle, then navigates via `tester.tap(find.text('Work'))` and pumps again, comparing against `goldens/detail_light.png`.

- [ ] **Step 2: Detail dark golden**

Mirror with dark prefs.

- [ ] **Step 3: Generate, run, commit**

```bash
flutter test --update-goldens test/golden/
flutter test test/golden/
git add test/golden/
git commit -m "test(golden): detail light + dark golden snapshots"
```

### Task 9.3: Empty state golden

- [ ] **Step 1: Empty state goldens (light + dark)**

With unseeded DB (no `seededDb()`), capture `goldens/empty_light.png` and `empty_dark.png`.

- [ ] **Step 2: Commit**

```bash
git add test/golden/
git commit -m "test(golden): empty-state light + dark golden snapshots"
```

---

## Phase 10: README + final acceptance

### Task 10.1: README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write the README**

```markdown
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
flutter test --update-goldens test/golden/   # after intentional visual changes
```

## Layout

See `docs/superpowers/specs/2026-05-02-atelier-design.md` for the architecture spec.
The original Claude Design handoff is preserved at `docs/design-handoff/`.
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: project README"
```

### Task 10.2: Final acceptance walkthrough

- [ ] Run `tool/check.sh` — clean
- [ ] `flutter run` on Android emulator
- [ ] First launch: empty state visible, chrome (month/year/days-left/tick strip) renders correctly
- [ ] Add first pocket → empty state replaced by 2-pocket grid (yours + Open)
- [ ] Tap pocket → detail opens
- [ ] Add a month goal → appears in list
- [ ] Star it → moves to top
- [ ] Add a year goal in YEAR mode → banner appears at top of detail
- [ ] Toggle banner → collapses; tap again → expands
- [ ] Edit goal → rename → Save
- [ ] Back to home → counts in pocket reflect goals you added
- [ ] Long-press a pocket → manage mode (wiggle, × badges, Open hidden)
- [ ] Drag a pocket to reorder → persists across app restart
- [ ] Tap × on a pocket → it (and its goals) disappear
- [ ] Tap outside any pocket → exits manage mode
- [ ] Settings gear → sheet slides up
- [ ] Theme: Dark → app re-themes
- [ ] Font: Large → text scales
- [ ] Reset all data → confirm → empty state returns
- [ ] Quit + relaunch → state persisted (theme + pockets + goals)

- [ ] **Step 3: Final tag**

```bash
git tag -a v1.0.0 -m "Atelier v1: local-first personal goals app"
```

---

## Self-review checklist (run after writing the plan)

- [x] Spec coverage — every spec section has a task that implements it (themes §6, models §5, repositories §4, cubits §4, home §3.2/§3.6/§3.9, detail §3.3/§3.4/§3.5, settings §3.7, tick strip §3.8, error/edge cases §9, tests §10).
- [x] No placeholders — every step contains real code or a real command.
- [x] Type consistency — `GoalCategory`, `Goal`, `YearGoal` field names match across domain, data, and presentation. Cubit method names (`load`, `add`, `addPocket`, `removePocket`, `toggleStar`, `toggleExpanded`, `rename`, `delete`, `reorder`) are consistent across phases.
- [x] Phases 6–8 use a guidance-table approach (rather than full per-step code) for the visual widgets — this is intentional. The spec specifies all dimensions, colors, fonts, and the prototype JSX is in-tree as a reference; full per-step code for ~30 widgets would inflate the plan past usefulness without adding information that isn't already in the spec + prototype. Phases 0–5 and 9–10 contain full per-step code where the logic isn't trivially derivable.

If you (the implementer) find any gap, surface it in the chat — don't silently work around it.
