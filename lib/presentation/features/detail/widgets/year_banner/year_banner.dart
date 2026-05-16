import 'package:atelier/domain/models/year_goal.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_collapsed.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_empty_state.dart';
import 'package:atelier/presentation/features/detail/widgets/year_banner/year_banner_expanded.dart';
import 'package:flutter/material.dart';

class YearBanner extends StatelessWidget {
  const YearBanner({
    super.key,
    required this.yearGoal,
    required this.categoryName,
    required this.onToggle,
    required this.onDelete,
    required this.onRename,
  });

  /// Null means no year goal exists for this category.
  final YearGoal? yearGoal;
  final String categoryName;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final void Function(String id, String title) onRename;

  @override
  Widget build(BuildContext context) {
    final yg = yearGoal;
    if (yg == null) {
      return YearBannerEmptyState(categoryName: categoryName);
    }
    if (yg.expanded) {
      return YearBannerExpanded(
        yearGoal: yg,
        onToggle: () => onToggle(yg.id),
        onDelete: () => onDelete(yg.id),
        onRename: (title) => onRename(yg.id, title),
      );
    }
    return YearBannerCollapsed(yearGoal: yg, onToggle: () => onToggle(yg.id));
  }
}
