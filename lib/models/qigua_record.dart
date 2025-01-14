// qigua_record.dart
import 'package:hive/hive.dart';

part 'qigua_record.g.dart'; // 记得加这行

@HiveType(typeId: 0)
class QiGuaRecord extends HiveObject {
  @HiveField(0)
  String qiGuaShiXiang;

  @HiveField(1)
  String date;

  @HiveField(2)
  String time;

  @HiveField(3)
  String liupai;

  @HiveField(4)
  String leixing;

  @HiveField(5)
  String detail;

  QiGuaRecord({
    required this.qiGuaShiXiang,
    required this.date,
    required this.time,
    required this.liupai,
    required this.leixing,
    required this.detail,
  });
}
