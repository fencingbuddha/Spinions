import 'package:flutter/material.dart';

class PersonalitySelector extends StatelessWidget {
  final String selected;

  final List<String> options;

  final ValueChanged<String> onChanged;

  const PersonalitySelector({
    super.key,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selected,
      items: options.map((mode) {
        return DropdownMenuItem<String>(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
