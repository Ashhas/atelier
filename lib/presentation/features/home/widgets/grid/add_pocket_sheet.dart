import 'package:atelier/presentation/features/home/state/goal_categories_cubit.dart';
import 'package:atelier/theme/atelier_spacing.dart';
import 'package:flutter/material.dart';

/// Modal bottom sheet body for adding a new pocket from the Open add-slot.
///
/// Holds its own [TextEditingController] so the input value survives keyboard
/// events. Submission (Enter or ADD button) calls [onSubmit] with the trimmed
/// name; an empty value short-circuits to a no-op pop.
class AddPocketSheet extends StatefulWidget {
  const AddPocketSheet({super.key, required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<AddPocketSheet> createState() => _AddPocketSheetState();
}

class _AddPocketSheetState extends State<AddPocketSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) widget.onSubmit(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AtelierSpacing.x3l,
        right: AtelierSpacing.x3l,
        top: AtelierSpacing.x3l,
        bottom: MediaQuery.of(context).viewInsets.bottom + AtelierSpacing.x3l,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(hintText: 'New pocket name…'),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: AtelierSpacing.base),
          TextButton(onPressed: _submit, child: const Text('ADD')),
        ],
      ),
    );
  }
}

/// Opens the add-pocket bottom sheet for [cubit].
///
/// The sheet is its own route, so cubits live above it via [BlocProvider]
/// at the app shell — passing the cubit explicitly keeps the sheet body
/// independent of provider scope.
Future<void> showAddPocketSheet(
  BuildContext context,
  GoalCategoriesCubit cubit,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => AddPocketSheet(onSubmit: cubit.addPocket),
  );
}
