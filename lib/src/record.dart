import 'package:hive/hive.dart';

part 'record.g.dart';

@HiveType(typeId: 0)
class Record extends HiveObject {
  @HiveField(0)
  String record;

  Record(this.record);
}
