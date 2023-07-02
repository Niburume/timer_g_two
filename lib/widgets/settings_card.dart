import 'package:flutter/material.dart';

class SettingsCard extends StatefulWidget {
  final String text;
  bool value;
  Function onTap;

  SettingsCard(
      {super.key,
      required this.text,
      required this.value,
      required this.onTap});

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.text),
            Switch(
              value: widget.value,
              onChanged: (value) {
                widget.onTap();
              },
            ),
          ],
        ),
      ),
    );
  }
}
