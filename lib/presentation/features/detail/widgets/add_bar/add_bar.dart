import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar_input.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar_placeholder.dart';
import 'package:atelier/presentation/features/detail/widgets/add_bar/add_bar_switch.dart';
import 'package:atelier/presentation/features/detail/state/goals_cubit.dart';
import 'package:atelier/presentation/features/detail/state/year_goals_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:atelier/theme/atelier_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBar extends StatefulWidget {
  const AddBar({super.key, required this.goalCategoryId});

  final String goalCategoryId;

  @override
  State<AddBar> createState() => _AddBarState();
}

class _AddBarState extends State<AddBar> {
  AddBarMode _mode = AddBarMode.month;
  bool _composing = false;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _composing = false);
      return;
    }
    if (_mode == AddBarMode.year) {
      context.read<YearGoalsCubit>().add(
        goalCategoryId: widget.goalCategoryId,
        title: text,
      );
    } else {
      context.read<GoalsCubit>().add(
        goalCategoryId: widget.goalCategoryId,
        title: text,
      );
    }
    _controller.clear();
    setState(() => _composing = false);
  }

  void _cancel() {
    _controller.clear();
    setState(() => _composing = false);
  }

  String get _placeholder => _mode == AddBarMode.month
      ? '+ Add to this month…'
      : '+ Add to ${DateTime.now().year}…';

  @override
  Widget build(BuildContext context) {
    final p = AtelierTheme.paletteOf(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AtelierSpacing.xl,
        0,
        AtelierSpacing.xl,
        AtelierSpacing.xl,
      ),
      padding: const EdgeInsets.all(AtelierSpacing.md),
      decoration: BoxDecoration(
        color: p.pocket,
        border: Border.all(color: p.rule),
        borderRadius: BorderRadius.circular(AtelierRadii.x2l),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          IntrinsicWidth(
            child: AddBarSwitch(
              mode: _mode,
              onChanged: (m) => setState(() => _mode = m),
            ),
          ),
          const SizedBox(width: AtelierSpacing.md),
          if (_composing)
            AddBarInput(
              controller: _controller,
              placeholder: _placeholder,
              onSubmit: _submit,
              onCancel: _cancel,
            )
          else
            AddBarPlaceholder(
              label: _placeholder,
              onTap: () => setState(() => _composing = true),
            ),
        ],
      ),
    );
  }
}
