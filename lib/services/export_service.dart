import 'dart:convert';
import 'dart:io';

import 'package:atelier/domain/models/app_settings.dart';
import 'package:atelier/domain/models/goal.dart';
import 'package:atelier/domain/models/goal_category.dart';
import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/domain/repositories/goal_category_repository.dart';
import 'package:atelier/domain/repositories/goal_repository.dart';
import 'package:atelier/domain/repositories/settings_repository.dart';
import 'package:atelier/domain/repositories/year_goal_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Snapshots every store and shares the result as a JSON file via the
/// platform share sheet (Drive, Files, Mail, AirDrop, …).
///
/// Mirrors the shape of [DataResetter]: a small service over the four repos,
/// instantiated once in `atelier_app.dart` and provided down the tree.
class ExportService {
  ExportService({
    required this.categories,
    required this.goals,
    required this.yearGoals,
    required this.settingsRepository,
  });

  final GoalCategoryRepository categories;
  final GoalRepository goals;
  final YearGoalRepository yearGoals;
  final SettingsRepository settingsRepository;

  /// Reads every store, builds a JSON document, writes it to the OS temp
  /// directory, and hands the file to the system share sheet.
  Future<void> share() async {
    final cats = await categories.all();
    final gs = await goals.all();
    final ygs = await yearGoals.all();
    final settings = await settingsRepository.read();

    final payload = _buildExportJson(
      categories: cats,
      goals: gs,
      yearGoals: ygs,
      settings: settings,
      exportedAt: DateTime.now().toUtc(),
    );

    final encoded = const JsonEncoder.withIndent('  ').convert(payload);

    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final file = File('${dir.path}/atelier-export-$stamp.json');
    await file.writeAsString(encoded);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/json')],
      subject: 'Atelier export',
    );
  }
}

/// Shape the JSON document however you'd like — this is the user-facing
/// contract of the export.
///
/// Things to decide:
///   • Top-level keys & their order. (`schemaVersion`, `exportedAt`,
///     `categories`, `goals`, `yearGoals`, `settings` — or a different cut?)
///   • Do goals/yearGoals nest inside their category, or stay flat with a
///     `goalCategoryId` reference? Flat round-trips losslessly; nested reads
///     more naturally for a human.
///   • Which fields to include per record. `id` and `addedAt` are useful for
///     re-import; drop them if you only care about content.
///   • How to render enums (`themeMode`, `fontScale`, `contentFont`) —
///     `.name` is the natural choice.
///   • Whether `starred` goals deserve a separate top-level array.
///
/// Return a `Map<String, dynamic>` ready for `JsonEncoder.withIndent`.
const int _schemaVersion = 1;

Map<String, dynamic> _buildExportJson({
  required List<GoalCategory> categories,
  required List<Goal> goals,
  required List<YearGoal> yearGoals,
  required AppSettings settings,
  required DateTime exportedAt,
}) {
  return {
    'schemaVersion': _schemaVersion,
    'exportedAt': exportedAt.toIso8601String(),
    'categories': [
      for (final c in categories.where((c) => !c.isAddSlot))
        {
          'id': c.id,
          'name': c.name,
          'order': c.order,
        },
    ],
    'goals': [
      for (final g in goals)
        {
          'id': g.id,
          'goalCategoryId': g.goalCategoryId,
          'title': g.title,
          'starred': g.starred,
          'addedAt': g.addedAt.toIso8601String(),
        },
    ],
    'yearGoals': [
      for (final y in yearGoals)
        {
          'id': y.id,
          'goalCategoryId': y.goalCategoryId,
          'title': y.title,
        },
    ],
    'settings': {
      'themeMode': settings.themeMode.name,
      'fontScale': settings.fontScale.name,
      'contentFont': settings.contentFont.name,
    },
  };
}
