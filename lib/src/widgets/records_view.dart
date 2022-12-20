import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:persistent_data/src/widgets/custom_modal_bottom_sheet.dart';
import 'package:persistent_data/src/widgets/description_view.dart';

import '../record.dart';

class RecordsView extends StatelessWidget {
  final String title;
  final Box<Record> box;

  const RecordsView({super.key, required this.title, required this.box});

  void _addRecord(String record) {
    box.add(Record(record));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, box, widget) {
          List<String> records =
              box.values.map((element) => element.record).toList();

          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (BuildContext context, int index) {
              final description = records[index].split('\n');

              return SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DescriptionView(
                            title: title, description: description),
                      ),
                    );
                  },
                  child: Text(description.first),
                ),
              );
            },
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
                action: _addRecord,
                isCategory: false,
              );
            },
          );
        },
        tooltip: 'Add record',
        child: const Icon(Icons.add),
      ),
    );
  }
}
