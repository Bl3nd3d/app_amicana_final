import 'package:flutter/material.dart';

class RadioGroup extends StatelessWidget {
  final int? groupValue;
  final List<String> options;
  final ValueChanged<int?> onChanged;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(options.length, (index) {
        return Card(
          color: groupValue == index
              ? const Color.fromRGBO(0, 0, 255, 0.3)
              : const Color.fromRGBO(255, 255, 255, 0.1),
          child: RadioListTile<int>(
            title: Text(options[index],
                style: const TextStyle(color: Colors.white)),
            value: index,
            // ignore: deprecated_member_use
            groupValue: groupValue,
            // ignore: deprecated_member_use
            onChanged: onChanged,
            activeColor: Colors.lightBlueAccent,
          ),
        );
      }),
    );
  }
}
