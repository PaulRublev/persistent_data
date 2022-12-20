import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_data/src/widgets/records_view.dart';

import '../record.dart';
import 'custom_modal_bottom_sheet.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  Map<String, Box<Record>?> boxes = {};

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  void _initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordAdapter());

    await _addBox('First');
    _addRecord(boxes['First'], 'record1\n213');
    _addRecord(boxes['First'], 'Abc2\nDe_fghi');
  }

  void _addRecord(Box<Record>? box, String record) async {
    box?.add(Record(record));
    setState(() {});
  }

  Future<void> _addBox(String category) async {
    boxes.addAll({category: null});
    boxes[category] = await Hive.openBox<Record>(category);
    setState(() {});
  }

  void _deleteBoxes() async {
    boxes = {};
    Hive.deleteFromDisk();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesKeys = boxes.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
              tooltip: 'Delete categories',
              onPressed: () {
                _deleteBoxes();
                setState(() {});
              },
              icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: ListView.builder(
        itemCount: categoriesKeys.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RecordsView(
                    title: categoriesKeys[index],
                    box: boxes[categoriesKeys[index]]!,
                  ),
                ));
              },
              child: Text(categoriesKeys[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return CustomModalBottomSheet(
                action: _addBox,
                isCategory: true,
              );
            },
          );
        },
        tooltip: 'Add category',
        child: const Icon(Icons.add),
      ),
    );
  }
}
