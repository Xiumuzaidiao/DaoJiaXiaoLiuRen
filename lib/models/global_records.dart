// global_records.dart
import 'package:hive/hive.dart';
import 'qigua_record.dart';

// 仅仅返回已经在 main.dart 打开的 Box<QiGuaRecord>
Box<QiGuaRecord> get qiguaBox => Hive.box<QiGuaRecord>('qigua_records');
