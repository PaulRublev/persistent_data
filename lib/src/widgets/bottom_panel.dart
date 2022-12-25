import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  final _editingController =
      TextEditingController(text: 'https://i.postimg.cc/1tf6qqQP/grozny.jpg');

  final Function setStateCallback;
  final Function(String) save;

  BottomPanel({super.key, required this.setStateCallback, required this.save});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextField(
              controller: _editingController,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await save(_editingController.value.text);
              setStateCallback(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
