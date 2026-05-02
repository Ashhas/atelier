import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:atelier/theme/atelier_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pill button that toggles into an inline text field for adding the first pocket.
///
/// Spec §3.9: pill button "+ ADD YOUR FIRST POCKET" in JetBrains Mono caps 10px,
/// letterSpacing 1.4, fontWeight 600, padding 12px 18px, background ink, color bg.
/// Tapping it shows a text field; Enter/submit calls [GoalCategoriesCubit.addPocket].
class HomeEmptyStateAction extends StatefulWidget {
  const HomeEmptyStateAction({super.key});

  @override
  State<HomeEmptyStateAction> createState() => _HomeEmptyStateActionState();
}

class _HomeEmptyStateActionState extends State<HomeEmptyStateAction> {
  bool _editing = false;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      context.read<GoalCategoriesCubit>().addPocket(name);
    }
    setState(() {
      _editing = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AtelierTheme.paletteOf(context);

    if (_editing) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          textAlign: TextAlign.center,
          style: AtelierTypography.monoLabel.copyWith(color: c.ink),
          decoration: InputDecoration(
            hintText: 'New pocket name…',
            hintStyle: AtelierTypography.monoLabel.copyWith(color: c.mute),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.pill),
              borderSide: BorderSide(color: c.rule),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.pill),
              borderSide: BorderSide(color: c.rule),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AtelierRadii.pill),
              borderSide: BorderSide(color: c.ink),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: AtelierSpacing.xl,
              horizontal: AtelierSpacing.x2l + AtelierSpacing.xs, // 18
            ),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _submit(),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _editing = true),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AtelierSpacing.xl, // 12≈14
          horizontal: AtelierSpacing.x2l + AtelierSpacing.xs, // 18
        ),
        decoration: BoxDecoration(
          color: c.ink,
          borderRadius: BorderRadius.circular(AtelierRadii.pill),
        ),
        child: Text(
          '+ ADD YOUR FIRST POCKET',
          style: AtelierTypography.monoLabel.copyWith(
            color: c.bg,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
