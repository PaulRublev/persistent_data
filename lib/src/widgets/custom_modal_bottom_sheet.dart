import 'package:flutter/material.dart';

class CustomModalBottomSheet extends StatelessWidget {
  final Function action;
  final bool isCategory;

  const CustomModalBottomSheet({
    super.key,
    required this.action,
    required this.isCategory,
  });

  @override
  Widget build(BuildContext context) {
    var editingController = TextEditingController(text: '');

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Add ${isCategory ? 'category' : 'record'}:'),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              maxLines: isCategory ? 1 : 2,
              textInputAction:
                  isCategory ? TextInputAction.none : TextInputAction.newline,
              controller: editingController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  action(editingController.value.text);
                  Navigator.pop(context);
                },
                child: const Icon(Icons.check_rounded),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
