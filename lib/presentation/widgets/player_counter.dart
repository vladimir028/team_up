import 'package:flutter/material.dart';

class PlayerCounterWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PlayerCounterWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(labelText),
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
