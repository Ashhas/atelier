import 'package:atelier/presentation/common/segmented/segmented.dart';
import 'package:atelier/presentation/common/segmented/segmented_option.dart';
import 'package:flutter/material.dart';

/// Segmented control for selecting between MONTH and YEAR add targets.
enum AddBarMode { month, year }

class AddBarSwitch extends StatelessWidget {
  const AddBarSwitch({super.key, required this.mode, required this.onChanged});

  final AddBarMode mode;
  final ValueChanged<AddBarMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Segmented<AddBarMode>(
      value: mode,
      options: const [
        SegmentedOptionData(value: AddBarMode.month, label: 'MONTH'),
        SegmentedOptionData(value: AddBarMode.year, label: 'YEAR'),
      ],
      onChanged: onChanged,
    );
  }
}
